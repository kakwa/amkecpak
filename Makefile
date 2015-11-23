# Name of the gpg key to use
GPG_KEY="kakwa (signing key for kakwa's packages) <carpentier.pf@gmail.com>"
# Output directory for the repo
OUTPUT="out/"
# Package provider
ORIGIN="kakwa"

PKG=$(shell find ./* -maxdepth 1 -type d -name pkg |grep -v '^common')
clean_PKG=$(addprefix clean_,$(PKG))
deb_PKG=$(addprefix deb_,$(PKG))
rpm_PKG=$(addprefix rpm_,$(PKG))
all: $(PKG)
clean: $(clean_PKG)
.PHONY: force rpm deb

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

deb_repo:
	mkdir -p $(OUTPUT)
	common/deb_repos.sh -p "$$(find `pwd` -type f -name "*.deb")" \
		-o $(OUTPUT) \
		-O $(ORIGIN) \
		-k $(GPG_KEY)
