# Name of the package
NAME = mock

VERSION = 1.4.21

UPSTREAM_RELEASE = 1

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/rpm-software-management/mock/releases/download

# short summary of what the package provides
SUMMARY=Not a package summary

# Long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

# License of the upstream project
LICENSE=Upstream License

# Distribution versions to skip
#
# format: space separated list of rules.
# each rule have the format "<op>:<dist>:<version>", with:
#   <op>:      the operation (must be  '>', '>=', '<', '<=' or '=')
#   <dist>:    the distribution code name (examples: 'deb', 'el', 'fc')
#   <version>: the version number to ignore
#
SKIP=>=:el:0 >=:fc:0
###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/mock-$(VERSION)-$(UPSTREAM_RELEASE)/mock-$(VERSION).tar.gz

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
	mv $(BUILD_DIR)/tmp/$(NAME)-$(NAME)-$(VERSION)-$(MOCK_RELEASE)/* $(SOURCE_DIR)
	rm -rf $(BUILD_DIR)/tmp
	rm -f $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	$(SOURCE_TAR_CMD)
