# Name of the gpg key to use
GPG_KEY=kakwa
# Output directory for the repos
OUTPUT=out/
# Package provider
ORIGIN=kakwa

#####################################################################

PKG=$(shell find ./* -maxdepth 1 -type d -name pkg |grep -v '^common')
clean_PKG=$(addprefix clean_,$(PKG))
deb_PKG=$(addprefix deb_,$(PKG))
rpm_PKG=$(addprefix rpm_,$(PKG))
OUTDEB=$(shell echo $(OUTPUT)/deb/`lsb_release -sc`/`dpkg --print-architecture`)
OUTRPM=$(shell echo $(OUTPUT)/rpm/`./common/buildenv/get_dist.sh`/`uname -m`/)

all:
	$(MAKE) rpm_repo
	$(MAKE) deb_repo

clean_pkg: $(clean_PKG)

deb: $(deb_PKG)
rpm: $(rpm_PKG)

$(PKG): force
	$(MAKE) -C $@

$(clean_PKG): force
	@+echo  $(MAKE) -C $(patsubst clean_%,%,$@) clean
	@$(MAKE) -C $(patsubst clean_%,%,$@) clean

$(deb_PKG): force
	@+echo  $(MAKE) -C $(patsubst deb_%,%,$@) deb
	@$(MAKE) -C $(patsubst deb_%,%,$@) deb

$(rpm_PKG): force
	@+echo  $(MAKE) -C $(patsubst rpm_%,%,$@) rpm
	@$(MAKE) -C $(patsubst rpm_%,%,$@) rpm

clean_deb_repo:
	-rm -rf "$(OUTDEB)"

clean_repo:
	-rm -rf "$(OUTPUT)"

clean_rpm_repo:
	-rm -rf "$(OUTRPM)"

deb_repo: $(deb_PKG) export_key
	@$(MAKE) clean_deb_repo
	mkdir -p $(OUTDEB)
	common/deb_repos.sh -p "$$(find `pwd` -type f -path '*/pkg/out/*.deb')" \
		-o $(OUTDEB) \
		-O $(ORIGIN) \
		-k $(GPG_KEY)

rpm_repo: $(rpm_PKG) export_key
	@$(MAKE) clean_rpm_repo
	mkdir -p $(OUTRPM)/RPMS/
	for r in $$(find `pwd` -type f -path '*/pkg/out/*.rpm'); do \
		cp $$r $(OUTRPM)/RPMS/ && \
		./common/rpmsign.exp $(OUTRPM)/RPMS/`basename $$r` --key-id=$(GPG_KEY) || exit 1; \
	done
	createrepo -o $(OUTRPM) $(OUTRPM)

export_key:
	mkdir -p $(OUTPUT)
	-rm -f $(OUTPUT)/pub.gpg
	gpg --armor --output $(OUTPUT)/pub.gpg --export "$(GPG_KEY)"

clean: clean_pkg clean_repo

.PHONY: force rpm deb deb_repo rpm_repo export_key clean_pkg clean_repo clean_rpm_repo clean_deb_repo
