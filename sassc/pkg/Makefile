# Name of the package
NAME = sassc

# Version
VERSION = 3.3.0

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/sass/sassc

# short summary of what the package provides
SUMMARY="Sass CSS pre-processor command line utilities"

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/archive/$(VERSION).tar.gz

#URL_SRC=https://github.com/sass/sassc/archive/3.3.0.tar.gz
# example of source archive handling:

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
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/sassc-$(VERSION).tar.gz
	tar -vxf $(BUILD_DIR)/sassc-$(VERSION).tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/sassc-$(VERSION)/* $(BUILD_DIR)/src/
	rm -rf $(BUILD_DIR)/sassc-$(VERSION)
	rm -f $(BUILD_DIR)/sassc-$(VERSION).tar.gz
	mv $(BUILD_DIR)/src/Makefile.new $(BUILD_DIR)/src/Makefile


# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
