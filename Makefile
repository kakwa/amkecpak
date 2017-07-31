# Name of the gpg key to use
GPG_KEY=kakwa
# Output directory for the repos
OUTPUT=out/
# Package provider
ORIGIN=kakwa

#####################################################################


PKG=$(shell find ./* -maxdepth 0 -type d |grep -v '^./common\|^./out')
clean_PKG=$(addprefix clean_,$(PKG))
deb_PKG=$(addprefix deb_,$(PKG))
deb_chroot_PKG=$(addprefix deb_chroot_,$(PKG))
rpm_PKG=$(addprefix rpm_,$(PKG))
manifest_PKG=$(addprefix manifest_,$(PKG))
OUTDEB=$(shell echo $(OUTPUT)/deb/`lsb_release -sc`/`dpkg --print-architecture`)
OUTRPM=$(shell echo $(OUTPUT)/rpm/$(DIST_TAG)/`uname -m`/)

# Must be declared before the include
LOCAL_REPO_PATH := $(shell pwd)/out/deb.$(DIST)/
COW_NAME := $(DIST).$(shell pwd | md5sum | sed 's/\ .*//').all.cow

include ./common/buildenv/Makefile.vars
include ./common/buildenv/Makefile.config

ifeq ($(ERROR), skip)
SKIP=-
endif

all:
	$(MAKE) rpm_repo
	$(MAKE) deb_repo

clean_pkg: $(clean_PKG)

deb: $(deb_PKG)
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

deb_chroot:
	mkdir -p out/deb.$(DIST)
	cd out/deb.$(DIST)/; dpkg-scanpackages . /dev/null >Packages
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
		cd out/deb.$(DIST)/; dpkg-scanpackages . /dev/null >Packages;cd -;\
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
	-rm -rf "$(OUTPUT)"

clean_rpm_repo:
	-rm -rf "$(OUTRPM)"

deb_repo: $(deb_PKG) export_key
	@$(MAKE) clean_deb_repo
	mkdir -p $(OUTDEB)
	common/deb_repos.sh -p "$$(find `pwd` -type f -path '*/out/*.deb')" \
		-o $(OUTDEB) \
		-O $(ORIGIN) \
		-k $(GPG_KEY)

rpm_repo: $(rpm_PKG) export_key
	@$(MAKE) clean_rpm_repo
	mkdir -p $(OUTRPM)/RPMS/
	for r in $$(find `pwd` -type f -path '*/out/*.rpm'); do \
		cp $$r $(OUTRPM)/RPMS/ && \
		./common/rpmsign.exp $(OUTRPM)/RPMS/`basename $$r` --key-id=$(GPG_KEY) || exit 1; \
	done
	createrepo -o $(OUTRPM) $(OUTRPM)

export_key:
	mkdir -p $(OUTPUT)
	-rm -f $(OUTPUT)/pub.gpg
	gpg --armor --output $(OUTPUT)/pub.gpg --export "$(GPG_KEY)"

clean: clean_pkg clean_repo

.PHONY: rpm deb deb_repo rpm_repo export_key\
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

               The targeted distribution version can be specified using
               the "DIST=<code name>", for example "make deb_chroot DIST=stretch"

               this target requires root permission for cowbuilder
               (sudo or run directly as root)


* rpm_chroot : not implemented yet

endef

export MAKE_HELP_MAIN
help:
	@echo "$$MAKE_HELP_MAIN"


#### END help target ####

