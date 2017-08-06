# Name of the package
NAME = mk-sh-skel

# Version
VERSION = 1.0.0

# Revision number
RELEASE = 1

# URL of the project
URL=https://github.com/kakwa/mk-sh-skel

# short summary of what the package provides
SUMMARY=Simple script to create script skeleton

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

# License of the package
LICENSE=MIT

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/archive/$(VERSION).tar.gz

# Including common rules and targets
include buildenv/Makefile.common

# preparation hook for rpm package
# source archives must recovered here
# and their content put inside $(BUILD_DIR)/src
#
# $(WGS) should be the prefered way to recover archives
# (add checksum against a manifest file).
# use 'make manifest' to generate/update this manifest file.

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
	$(WGS) -u $(URL_SRC) -o $(SOURCE_ARCHIVE)

#$(SOURCE_ARCHIVE): $(SOURCE_DIR) Makefile MANIFEST
#	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
#	mkdir -p $(BUILD_DIR)/tmp
#	tar -vxf $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz -C $(BUILD_DIR)/tmp
#	mv $(BUILD_DIR)/tmp/$(NAME)-$(VERSION)/* $(SOURCE_DIR)
#	rm -rf $(BUILD_DIR)/tmp
#	rm -f $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
#	$(SOURCE_TAR_CMD)
#
