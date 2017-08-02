# Name of the gpg key to use
GPG_KEY=kakwa
# Output directory for the repos
OUT_DIR=out/
# Package provider
ORIGIN=kakwa

#####################################################################


PKG=$(shell find ./* -maxdepth 0 -type d |grep -v '^./common\|^./out')
clean_PKG=$(addprefix clean_,$(PKG))
deb_PKG=$(addprefix deb_,$(PKG))
deb_chroot_PKG=$(addprefix deb_chroot_,$(PKG))
rpm_PKG=$(addprefix rpm_,$(PKG))
manifest_PKG=$(addprefix manifest_,$(PKG))
OUTDEB=$(shell echo $(OUT_DIR)/deb/`lsb_release -sc`/`dpkg --print-architecture`)
OUTRPM=$(shell echo $(OUT_DIR)/rpm/$(DIST_TAG)/`uname -m`/)

# Must be declared before the include
DEB_OUT_DIR := $(shell readlink -f $(OUT_DIR))/deb.$(DIST)/
LOCAL_REPO_PATH := $(DEB_OUT_DIR)/raw
COW_NAME := $(DIST).$(shell echo $(LOCAL_REPO_PATH) | md5sum | sed 's/\ .*//').all.cow

include ./common/buildenv/Makefile.vars
include ./common/buildenv/Makefile.config

export $(DEB_REPO_CONFIG)

ifeq ($(ERROR), skip)
SKIP=-
endif


ifeq ($(NOCHROOT), true)
DEB_REPO_DEP=deb
else
DEB_REPO_DEP=deb_chroot
endif

all:
	$(MAKE) rpm_repo
	$(MAKE) deb_repo

clean_pkg: $(clean_PKG)

deb_internal: $(deb_PKG)
deb_chroot_internal: $(deb_chroot_PKG)
rpm: $(rpm_PKG)

manifest: $(manifest_PKG)

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


deb:
	$(MAKE) deb_internal OUT_DIR=$(LOCAL_REPO_PATH)
# build all the .deb packages
# logic:
# * init the out directory (as a local repo)
# * init or update the cowbuilder chroot
# * loop over building the packages:
#   - try to build all packages (output in out directory/local repo)
#   - count package build failures
#   - if there are build failures (but no more than last iteration)
#     update the local repo, and loop to retry failed package builds
# * do a last build iteration to make sure every packages are build correctly
#
# The loop iteration permits to handle dependencies between built packages
deb_chroot:
	mkdir -p $(LOCAL_REPO_PATH)
	cd $(LOCAL_REPO_PATH); dpkg-scanpackages . /dev/null >Packages
	if ! [ -e $(COW_DIR)/$(COW_NAME) ];\
	then\
		export TMPDIR=/tmp/; \
		$(COW_SUDO) cowbuilder --create \
		  --basepath $(COW_DIR)/$(COW_NAME) \
		  --debootstrap debootstrap \
		  $(COW_DIST) $(OTHERMIRROR) \
		  --mirror $(DEB_MIRROR) \
		  $(BINDMOUNT) \
		  $(COW_UBUNTU) \
		  $(COW_OPTS);\
		ret=$$?;\
	else\
		export TMPDIR=/tmp/;\
		$(COW_SUDO) cowbuilder --update \
	      	  --basepath $(COW_DIR)/$(COW_NAME) \
		  $(BINDMOUNT);\
		ret=$$?;\
	fi; exit $$ret
	old=99998;\
	new=99999;\
	while [ $$new -ne $$old ] && [ $$new -ne 0 ];\
	do\
		$(MAKE) deb_chroot_internal ERROR=skip \
		        OUT_DIR=$(LOCAL_REPO_PATH) \
			LOCAL_REPO_PATH=$(LOCAL_REPO_PATH) \
			COW_NAME=$(COW_NAME) \
			SKIP_COWBUILDER_SETUP=true;\
		old=$$new;\
		new=$$(find ./ -type f -name "failure.chroot.$(DIST)" | wc -l);\
		cd $(LOCAL_REPO_PATH); dpkg-scanpackages . /dev/null >Packages;cd -;\
		if [ $$new -ne 0 ];\
		then\
			export TMPDIR=/tmp/;\
			$(COW_SUDO) cowbuilder --update \
			  --basepath $(COW_DIR)/$(COW_NAME) \
			  $(BINDMOUNT);\
		fi;\
	done
	$(MAKE) deb_chroot_internal OUT_DIR=$(LOCAL_REPO_PATH) LOCAL_REPO_PATH=$(LOCAL_REPO_PATH) \
		COW_NAME=$(COW_NAME) SKIP_COWBUILDER_SETUP=true

clean_deb_repo:
	-rm -rf "$(OUTDEB)"

clean_repo:
	-rm -rf "$(OUT_DIR)"

clean_rpm_repo:
	-rm -rf "$(OUTRPM)"

deb_repo: $(DEB_REPO_DEP) export_key
	$(MAKE) internal_deb_repo

$(DEB_OUT_DIR)/conf/distributions: common/buildenv/Makefile.config
	mkdir -p $(DEB_OUT_DIR)/conf/
	echo "$$DEB_REPO_CONFIG" >$(DEB_OUT_DIR)/conf/distributions

DEBS = $(wildcard find $(LOCAL_REPO_PATH)/*.deb)

$(DEB_OUT_DIR)/dists/$(DIST)/InRelease: $(DEBS) $(DEB_OUT_DIR)/conf/distributions
	ls $(LOCAL_REPO_PATH)/*.deb
	echo $(DEBS)
	cd $(DEB_OUT_DIR) &&\
	for deb in $(DEBS);\
	do\
	  reprepro -P optional -S $(PKG_ORIGIN) -C $(DEB_REPO_COMPONENT) \
	  -Vb . includedeb $(DIST) $$deb || exit 1;\
	done


internal_deb_repo: $(DEB_OUT_DIR)/dists/$(DIST)/InRelease

rpm_repo: $(rpm_PKG) export_key
	@$(MAKE) clean_rpm_repo
	mkdir -p $(OUTRPM)/RPMS/
	for r in $$(find `pwd` -type f -path '*/out/*.rpm'); do \
		cp $$r $(OUTRPM)/RPMS/ && \
		./common/rpmsign.exp $(OUTRPM)/RPMS/`basename $$r` --key-id=$(GPG_KEY) || exit 1; \
	done
	createrepo -o $(OUTRPM) $(OUTRPM)

export_key: $(OUT_DIR)/GPG-KEY.pub

$(OUT_DIR)/GPG-KEY.pub:
	mkdir -p $(OUT_DIR)
	gpg --armor --output $(OUT_DIR)/GPG-KEY.pub --export "$(GPG_KEY)"

clean: clean_pkg clean_repo

.PHONY: internal_deb_repo rpm deb deb_repo rpm_repo export_key\
  clean_pkg clean_repo clean_rpm_repo clean_deb_repo help \
  deb_chroot deb_chroot_internal

#### START help target ####

define MAKE_HELP_MAIN

General advices:

If you want to speed-up build, use the usual -j parameter, for example:

make clean -j 10
make deb -j 10

If you want to ignore package build failures, add ERROR=skip, for example:

make deb ERROR=skip


Available targets:

* help       : Display this help


* clean      : Remove all packages work directories.

               It's possible to keep the cache directories
               with "KEEP_CACHE=true": "make clean KEEP_CACHE=true"


* deb        : Build all the .deb packages


* rpm        : Build all the .rpm packages


* deb_chroot : Build all the .deb packages in a clean chroot (using cowbuilder)

               The targeted distribution version must be specified using
               option "DIST=<code name>", for example "make deb_chroot DIST=stretch"

               this target requires root permission for cowbuilder
               (sudo or run directly as root)

* deb_repo   : Build the .deb repository from the .deb generated by target deb or deb_chroot

               Option "DIST=<code name>" must be specified correctly.

               By default, all packages will be built in individual, clean chroots.
	       However, if you want to build directly from host (no chroot) setting
	       the option NOCHROOT=true.
	       This will speed-up build, but it requires that you handle having the 
	       proper build depedencies on the host yourself.

* rpm_chroot : not implemented yet

endef

export MAKE_HELP_MAIN
help:
	@echo "$$MAKE_HELP_MAIN"


#### END help target ####

