# Name of the package
NAME = libvisio2svg

# Version
VERSION = 0.3.0

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/kakwa/libvisio2svg

# short summary of what the package provides
SUMMARY="visio to SVG conversion library"

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

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

src_prepare_rpm:
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/libvisio2svg-$(VERSION).tar.gz
	tar -vxf $(BUILD_DIR)/libvisio2svg-$(VERSION).tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/libvisio2svg-$(VERSION)/* $(BUILD_DIR)/src/
	rm -rf $(BUILD_DIR)/libvisio2svg-$(VERSION)
	rm -f $(BUILD_DIR)/libvisio2svg-$(VERSION).tar.gz


# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
