# Name of the package
NAME = kakwa-samba

# Version
VERSION = 4.4.5

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://download.samba.org/pub/samba/stable/

# short summary of what the package provides
SUMMARY="Not a package summary"

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/samba-$(VERSION).tar.gz

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
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/samba-$(VERSION).tar.gz
	tar -vxf $(BUILD_DIR)/samba-$(VERSION).tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/samba-$(VERSION)/* $(BUILD_DIR)/src/
	find $(BUILD_DIR)/src/ -name configure.rpm -exec rm {} \;
	rm -rf $(BUILD_DIR)/samba-$(VERSION)
	rm -f $(BUILD_DIR)/samba-$(VERSION).tar.gz


# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
