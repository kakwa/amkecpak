# Configuration
# ----------------------------------------------------------------------------
ifneq ($(wildcard Makefile.config),)
    include Makefile.config
endif

# Package Discovery
# ----------------------------------------------------------------------------
PKG := $(shell find ./* -maxdepth 0 -type d | grep -v '^./common\|^./out')
clean_PKG := $(addprefix clean_,$(PKG))
deb_PKG := $(addprefix deb_,$(PKG))
deb_chroot_PKG := $(addprefix deb_chroot_,$(PKG))
rpm_chroot_PKG := $(addprefix rpm_chroot_,$(PKG))
rpm_PKG := $(addprefix rpm_,$(PKG))
manifest_PKG := $(addprefix manifest_,$(PKG))

# Output Directories
# ----------------------------------------------------------------------------
OUTDEB := $(OUT_DIR)/deb/$(DIST)/$(ARCH)
OUTRPM := $(OUT_DIR)/rpm/$(DIST_TAG)/$(ARCH)

# Build Directory Structure
BUILD_DIR := builddir/$(ARCH)

# Success/Failure Markers
SUCCESS_MARKER := success.$(ARCH)
FAILURE_MARKER := failure.$(ARCH)
FAILURE_CHROOT_MARKER := failure.chroot.$(DIST).$(ARCH)
FAILURE_RPM_CHROOT_MARKER := failure.rpm.chroot.$(DIST).$(ARCH)

# Must be declared before the include
# Include Configuration Files
# ----------------------------------------------------------------------------
include ./common/buildenv/Makefile.vars

DEB_OUT_DIR := $(shell readlink -f $(OUT_DIR))/deb.$(DIST).$(ARCH)
LOCAL_REPO_PATH := $(DEB_OUT_DIR)/raw

RPM_LOCAL_REPO_PATH := $(RPM_OUT_DIR)/raw
RPM_OUT_DIR := $(shell readlink -f $(OUT_DIR))/rpm.$(DIST).$(ARCH)
RPM_OUT_REPO := $(RPM_OUT_DIR)/$(DIST_TAG)/$(ARCH)

# Export Configuration
# ----------------------------------------------------------------------------
export $(DEB_REPO_CONFIG)

# Error Handling
# ----------------------------------------------------------------------------
ifeq ($(ERROR), skip)
SKIP := -
endif

# Build Environment Selection
# ----------------------------------------------------------------------------
ifeq ($(NOCHROOT), true)
DEB_REPO_DEP := deb
else
DEB_REPO_DEP := deb_chroot
endif

ifeq ($(NOCHROOT), true)
RPM_REPO_DEP := rpm
else
RPM_REPO_DEP := rpm_chroot
endif

# Main Targets
# ----------------------------------------------------------------------------
all:
	@$(MAKE) deb_repo

clean_pkg: $(clean_PKG)

deb_internal: $(deb_PKG)
rpm_internal: $(rpm_PKG)

deb_chroot_internal: $(deb_chroot_PKG)
rpm_chroot_internal: $(rpm_chroot_PKG)

manifest: $(manifest_PKG)

# Utility Targets
# ----------------------------------------------------------------------------
list_dist:
	@sed -e 's/  \(.*\).*/\1/;tx;d;:x' ./common/buildenv/get_dist.sh | grep -v echo | sed 's/\(.*\))/* \1/'

# Package Targets
# ----------------------------------------------------------------------------
$(PKG):
	$(MAKE) -C $@

$(clean_PKG):
	@+echo  $(MAKE) -C $(patsubst clean_%,%,$@) clean
	@$(MAKE) -C $(patsubst clean_%,%,$@) clean

$(deb_chroot_PKG):
	@+echo  $(MAKE) -C $(patsubst deb_chroot_%,%,$@) deb_chroot
	$(SKIP)@$(MAKE) -C $(patsubst deb_chroot_%,%,$@) deb_chroot

$(deb_PKG):
	@+echo  $(MAKE) -C $(patsubst deb_%,%,$@) deb
	$(SKIP)@$(MAKE) -C $(patsubst deb_%,%,$@) deb

$(manifest_PKG):
	@+echo  $(MAKE) -C $(patsubst manifest_%,%,$@) manifest
	$(SKIP)@$(MAKE) -C $(patsubst manifest_%,%,$@) manifest

$(rpm_PKG):
	@+echo  $(MAKE) -C $(patsubst rpm_%,%,$@) rpm
	$(SKIP)@$(MAKE) -C $(patsubst rpm_%,%,$@) rpm

$(rpm_chroot_PKG):
	@+echo  $(MAKE) -C $(patsubst rpm_chroot_%,%,$@) rpm_chroot
	$(SKIP)@$(MAKE) -C $(patsubst rpm_chroot_%,%,$@) rpm_chroot

# Simplified Package Build Targets
# ----------------------------------------------------------------------------
deb:
	$(MAKE) deb_internal

rpm:
	$(MAKE) rpm_internal

# Debian Build Target (Chroot)
deb_chroot:
	# Initialize output directory as local repo
	@mkdir -p $(LOCAL_REPO_PATH)
	@cd $(LOCAL_REPO_PATH) && dpkg-scanpackages . /dev/null > Packages
	@$(SUDO) mkdir -p $(COW_DIR)/aptcache/
	
	# Initialize or update cowbuilder chroot
	@if ! [ -f $(COW_BASEPATH)/etc/hosts ]; then \
		export TMPDIR=/tmp/; \
		$(SUDO) rm -rf -- $(COW_BASEPATH); \
		$(SUDO) cowbuilder --create $(COWBUILDER_CREATE_ARGS); \
	else \
		export TMPDIR=/tmp/; \
		$(SUDO) cowbuilder --update $(COWBUILDER_UPDATE_ARGS); \
	fi
	
	# loop over building the packages:
	#  - count package build failures
	#  - if there are build failures (but no more than last iteration)
	#    update the local repo, and loop to retry failed package builds
	# This loop is a bruteforce way to deal with build ordering dependencies
	@old=99998;\
	new=99999;\
	while [ $$new -ne $$old ] && [ $$new -ne 0 ];\
	do\
		$(MAKE) deb_chroot_internal ERROR=skip \
		        UPDATE_REPO=false \
			COW_NAME=$(COW_NAME) \
			SKIP_COWBUILDER_SETUP=true;\
		old=$$new;\
		new=$$(find ./ -type f -name "failure.chroot.$(DIST).$(ARCH)" | wc -l);\
		cd $(LOCAL_REPO_PATH) && dpkg-scanpackages . /dev/null >Packages || exit 1;cd -;\
		if [ $$new -ne 0 ];\
		then\
			export TMPDIR=/tmp/;\
			$(SUDO) cowbuilder --update $(COWBUILDER_UPDATE_ARGS); \
		fi;\
	done
	
	# do a last build iteration to make sure every packages are build correctly
	@$(MAKE) deb_chroot_internal UPDATE_REPO=false \
		COW_NAME=$(COW_NAME) SKIP_COWBUILDER_SETUP=true

# Build Status Reporting
# ----------------------------------------------------------------------------
deb_failed:
	@echo "Package(s) for DIST '$(DIST)' ARCH '$(ARCH)' that failed to build:"
	@find ./ -type f -name "failure.chroot.$(DIST).$(ARCH)" | sed 's|\./\([^/]*\)/.*|* \1|'

rpm_failed:
	@echo "Package(s) for DIST '$(DIST)' ARCH '$(ARCH)' that failed to build:"
	@find ./ -type f -name "failure.rpm.chroot.$(DIST).$(ARCH)" | sed 's|\./\([^/]*\)/.*|* \1|'

# RPM Build Target (Chroot)
# ----------------------------------------------------------------------------
rpm_chroot:
	old=99998;\
	new=99999;\
	while [ $$new -ne $$old ] && [ $$new -ne 0 ];\
	do\
		$(MAKE) rpm_chroot_internal ERROR=skip;\
		old=$$new;\
		new=$$(find ./ -type f -name "failure.rpm.chroot.$(DIST).$(ARCH)" | wc -l);\
		echo $$new -ne $$old;\
	done
	$(MAKE) rpm_chroot_internal

# Utility Functions
# ----------------------------------------------------------------------------
deb_get_chroot_path:
	@echo `readlink -f $(COW_BASEPATH)`

# Cleanup Targets
# ----------------------------------------------------------------------------
clean_deb_repo:
	-rm -rf "$(OUTDEB)"

clean_repo:
	-rm -rf "$(OUT_DIR)"

clean_rpm_repo:
	-rm -rf "$(OUTRPM)"

# Debian Repository Creation
# ----------------------------------------------------------------------------
deb_repo: $(DEB_REPO_DEP) $(OUT_DIR)/GPG-KEY.pub
	$(MAKE) internal_deb_repo

$(DEB_OUT_DIR)/conf/distributions:
	mkdir -p $(DEB_OUT_DIR)/conf/
	echo "$$DEB_REPO_CONFIG" >$(DEB_OUT_DIR)/conf/distributions

DEBS = $(shell ls -tr $(LOCAL_REPO_PATH)/*.deb 2>/dev/null)

$(DEB_OUT_DIR)/dists/$(DIST)/InRelease: $(DEBS) $(DEB_OUT_DIR)/conf/distributions
	cd $(DEB_OUT_DIR) &&\
	for deb in $(DEBS);\
	do\
	  reprepro -C $(DEB_REPO_COMPONENT) remove $(DIST) `dpkg-deb -W $$deb | sed 's/\t.*//'` ;\
	  reprepro -P optional -S $(PKG_ORIGIN) -C $(DEB_REPO_COMPONENT) \
	  -Vb . includedeb $(DIST) $$deb || exit 1;\
	done

internal_deb_repo: $(DEB_OUT_DIR)/dists/$(DIST)/InRelease

# RPM Repository Creation
# ----------------------------------------------------------------------------
RPMS = $(shell find $(RPM_LOCAL_REPO_PATH) -name '*.rpm' -not -name '*.src.rpm' 2>/dev/null)
SRC_RPMS = $(shell find $(RPM_LOCAL_REPO_PATH) -name '*.src.rpm' 2>/dev/null)

OUT_RPMS = $(shell echo $(RPMS) | tr ' ' '\n' | sed 's|.*/|$(RPM_OUT_REPO)|g')

$(RPM_OUT_REPO):
	mkdir -p $(RPM_OUT_REPO)

$(OUT_RPMS): $(RPMS) | $(RPM_OUT_REPO)
	cp $(shell find $(RPM_LOCAL_REPO_PATH) -name `basename $@`) $@
	rpmsign --addsign --key-id=$(GPG_KEY) $@

rpm_sign: $(OUT_RPMS)

$(RPM_OUT_REPO)/repodata: $(OUT_RPMS)
	createrepo_c -o $(RPM_OUT_REPO) $(RPM_OUT_REPO)

internal_rpm_repo: $(RPM_OUT_REPO)/repodata

rpm_repo: $(RPM_REPO_DEP) $(OUT_DIR)/GPG-KEY.pub
	$(MAKE) internal_rpm_repo

# GPG Key Export
# ----------------------------------------------------------------------------
export_key: $(OUT_DIR)/GPG-KEY.pub

$(OUT_DIR)/GPG-KEY.pub:
	mkdir -p $(OUT_DIR)
	gpg --armor --output $(OUT_DIR)/GPG-KEY.pub --export "$(GPG_KEY)"

# Main Cleanup Target
# ----------------------------------------------------------------------------
clean: clean_pkg clean_repo

# Phony Targets Declaration
# ----------------------------------------------------------------------------
.PHONY: internal_deb_repo rpm deb deb_repo rpm_repo export_key\
  clean_pkg clean_repo clean_rpm_repo help \
  deb_chroot deb_internal deb_chroot_internal deb_get_chroot_path list_dist \
  rpm_repo rpm_chroot_internal rpm_chroot

# Help Target
# ----------------------------------------------------------------------------
define MAKE_HELP_MAIN
targets:
* help      : Display this help
* clean     : Clean work directories.
              Use "make clean KEEP_CACHE=true" to keep downloaded content.
* deb       : Build all .deb
* deb_chroot: Build all .deb in build chroots (using cowbuilder)
              option "DIST=<code name>", for example "make deb_chroot DIST=stretch"
* deb_repo  : Build the complete .deb repo
              Option "DIST=<code name>" must be specified.
* rpm       : Build all .rpm packages
* rpm_chroot: Build all .rpm packages in build chroots (using mock/mockchain)
              The targeted distribution version must be specified using
              option "DIST=<code name>", for example "make rpm_chroot DIST=el7"
* rpm_repo  : Build the .rpm repository.
              Option "DIST=<code name>" must be specified.
endef

export MAKE_HELP_MAIN
help:
	@echo "$$MAKE_HELP_MAIN"
