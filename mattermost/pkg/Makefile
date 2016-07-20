# Name of the package
NAME = mattermost

# Version
VERSION = 3.2.0

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/mattermost/platform

# short summary of what the package provides
SUMMARY="Not a package summary"

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/archive/v$(VERSION).tar.gz

# Including common rules and targets 
include buildenv/Makefile.common

# preparation hook for rpm package
# source archives must recovered here
# and their content put inside $(BUILD_DIR)/src
#
# $(WGS) should be the prefered way to recover archives
# (add checksum against a manifest file).
# use 'make manifest' to generate/update this manifest file.

src_prepare_rpm:
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/mattermost-$(VERSION).tar.gz
	tar -vxf $(BUILD_DIR)/mattermost-$(VERSION).tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/platform-$(VERSION)/* $(BUILD_DIR)/src/
	rm -rf $(BUILD_DIR)/platform-$(VERSION)
	rm -f $(BUILD_DIR)/mattermost-$(VERSION).tar.gz


# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
