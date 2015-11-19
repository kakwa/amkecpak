PKG=$(shell find ./* -maxdepth 1 -type d -name pkg |grep -v '^common')
clean_PKG=$(addprefix clean_,$(PKG))
deb_PKG=$(addprefix deb_,$(PKG))
rpm_PKG=$(addprefix rpm_,$(PKG))
all: $(PKG)
clean: $(clean_PKG)
.PHONY: force

deb: $(deb_PKG)
rpm: $(rpm_PKG)

$(PKG): force
	$(MAKE) -C $@

$(clean_PKG): force
	+echo  $(MAKE) -C $(patsubst clean_%,%,$@) clean
	@$(MAKE) -C $(patsubst clean_%,%,$@) clean

$(deb_PKG): force
	+echo  $(MAKE) -C $(patsubst deb_%,%,$@) deb
	@$(MAKE) -C $(patsubst deb_%,%,$@) deb

$(rpm_PKG): force
	@+echo  $(MAKE) -C $(patsubst rpm_%,%,$@) rpm
	@$(MAKE) -C $(patsubst rpm_%,%,$@) rpm

