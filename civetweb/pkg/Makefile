# Name of the package
NAME = civetweb

# Version
VERSION = 1.9.1.9999

GIT_REV=f590189b2372ca82301862fc8ff3bef6d8cc046e

# Revision number 
RELEASE = 2

# URL of the project 
URL=https://github.com/civetweb/civetweb

# short summary of what the package provides
SUMMARY="Embedded C/C++ web server"

# long version of the summary, but I'm lazy
DESCRIPTION="$(SUMMARY), under MIT (Mongoose fork)"

###############################################################################
# Rule #
########

# example of source recovery url
#URL_SRC=$(URL)/archive/v$(VERSION).tar.gz
URL_SRC=$(URL)/archive/$(GIT_REV).tar.gz

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
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/civetweb-$(VERSION).tar.gz
	tar -vxf $(BUILD_DIR)/civetweb-$(VERSION).tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/civetweb-$(GIT_REV)/* $(BUILD_DIR)/src/
	rm -rf $(BUILD_DIR)/civetweb-$(GIT_REV)
	rm -f $(BUILD_DIR)/civetweb-$(VERSION).tar.gz


# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
