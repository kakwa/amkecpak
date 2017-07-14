# Name of the package
NAME = python-asciigraph

# Version
VERSION = 1.1.3

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/kakwa/py-ascii-graph

# short summary of what the package provides
SUMMARY="ascii histogram library"

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

URL_SRC=$(URL)/archive/$(VERSION).tar.gz

###############################################################################
# Rule #
########

# Including common rules and targets 
include buildenv/Makefile.common

# preparation hook for rpm package
# source archives must recovered here
# and their content put inside $(BUILD_DIR)/src
#
# $(WGS) should be the prefered way to recover archives
# (add checksum against a manifest file).
# use 'make manifest' to generate/update this manifest file.

$(SOURCE_ARCHIVE): $(SOURCE_DIR) Makefile MANIFEST $(CACHE)
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/py-ascii-graph-$(VERSION).tar.gz
	mkdir -p $(BUILD_DIR)/tmp
	tar -vxf $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz -C $(BUILD_DIR)/tmp
	mv $(BUILD_DIR)/tmp/py-ascii-graph-$(VERSION)/* $(SOURCE_DIR)
	rm -rf $(BUILD_DIR)/tmp
	rm -f $(BUILD_DIR)/py-ascii-graph-$(VERSION).tar.gz
	$(SOURCE_TAR_CMD)

