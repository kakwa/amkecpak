# Name of the package
NAME = globalprotect-openconnect

# Version
VERSION = 1.3.4

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/yuezk/GlobalProtect-openconnect/

# short summary of what the package provides
SUMMARY=A GlobalProtect VPN client (GUI) based on OpenConnect.

# Long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

# License of the upstream project
LICENSE=GPLv3

# Distribution versions to skip
#
# format: space separated list of rules.
# each rule have the format "<op>:<dist>:<version>", with:
#   <op>:      the operation (must be  '>', '>=', '<', '<=' or '=')
#   <dist>:    the distribution code name (examples: 'deb', 'el', 'fc')
#   <version>: the version number to ignore
#
SKIP=<=:deb:8 >=:el:0 >=:fc:0 <=:ubu:18.4

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/releases/download/v$(VERSION)/globalprotect-openconnect-$(VERSION).tar.gz

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

# more complex case with upstream source rework and rebuilding of the tar
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	mkdir -p $(BUILD_DIR)/tmp
	tar -vxf $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz -C $(BUILD_DIR)/tmp
	rm -rf $(BUILD_DIR)/tmp/$(NAME)-$(VERSION)/debian
	mv $(BUILD_DIR)/tmp/$(NAME)-$(VERSION)/* $(SOURCE_DIR)
	rm -rf $(BUILD_DIR)/tmp
	rm -f $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	$(SOURCE_TAR_CMD)
