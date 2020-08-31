# Name of the package
NAME = snes9x

# Version
VERSION = 1.60

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/snes9xgit/snes9x

# short summary of what the package provides
SUMMARY=Snes9x - Portable Super Nintendo Entertainment System (TM) emulator

# Long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

# License of the upstream project
LICENSE=GPLv2

# Distribution versions to skip
#
# format: space separated list of rules.
# each rule have the format "<op>:<dist>:<version>", with:
#   <op>:      the operation (must be  '>', '>=', '<', '<=' or '=')
#   <dist>:    the distribution code name (examples: 'deb', 'el', 'fc')
#   <version>: the version number to ignore
#
SKIP=<=:deb:9 >=:el:0 >=:fc:0 <=:ubu:18.4

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=https://github.com/snes9xgit/snes9x

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

# Example of simple recovery, with good upstream
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
	$(GS) -u $(URL_SRC) -o $(SOURCE_ARCHIVE) -t $(VERSION) -s

# more complex case with upstream source rework and rebuilding of the tar
#$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
#	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
#	mkdir -p $(BUILD_DIR)/tmp
#	tar -vxf $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz -C $(BUILD_DIR)/tmp
#	rm -rf $(BUILD_DIR)/tmp/$(NAME)-$(VERSION)/debian
#	mv $(BUILD_DIR)/tmp/$(NAME)-$(VERSION)/* $(SOURCE_DIR)
#	rm -rf $(BUILD_DIR)/tmp
#	rm -f $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
#	$(SOURCE_TAR_CMD)
