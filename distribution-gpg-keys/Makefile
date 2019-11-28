# Name of the package
NAME = distribution-gpg-keys

# Version
VERSION = 1.35

UPSTREAM_RELEASE = 1

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/xsuchy/distribution-gpg-keys

# short summary of what the package provides
SUMMARY=Collection of GPG keys used in Linux Distributions

# Long version of the summary, but I'm lazy
DESCRIPTION=Collection of GPG keys used in Linux Distributions

# License of the upstream project
LICENSE=CC0

# Distribution versions to skip
#
# format: space separated list of rules.
# each rule have the format "<op>:<dist>:<version>", with:
#   <op>:      the operation (must be  '>', '>=', '<', '<=' or '=')
#   <dist>:    the distribution code name (examples: 'deb', 'el', 'fc')
#   <version>: the version number to ignore
#
#SKIP=<=:deb:8 <=:el:6 <=:fc:29 <=:ubu:18.4

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/archive/distribution-gpg-keys-$(VERSION)-$(UPSTREAM_RELEASE).tar.gz

# Including common rules and targets 
include buildenv/Makefile.common

# preparation hook for sources
# source archive must be recovered here, optionaly reworked, and
# moved to $(SOURCE_ARCHIVE) (the expected path of the source archive for the
# rest of the build)
#
# $(WGS) should be the prefered way to recover archives
# (add checksum against a manifest file).
# use 'make manifest' to generate/update this manifest file.
#
# Example of simple recovery, with good upstream
#$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
#	$(WGS) -u $(URL_SRC) -o $(SOURCE_ARCHIVE)

# more complex case with upstream source rework and rebuilding of the tar
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	mkdir -p $(BUILD_DIR)/tmp
	tar -vxf $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz -C $(BUILD_DIR)/tmp
	mv $(BUILD_DIR)/tmp/$(NAME)-$(NAME)-$(VERSION)-$(UPSTREAM_RELEASE)/* $(SOURCE_DIR)
	rm -rf $(BUILD_DIR)/tmp
	rm -f $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	$(SOURCE_TAR_CMD)
