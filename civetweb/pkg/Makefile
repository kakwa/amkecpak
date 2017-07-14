# Name of the package
NAME = civetweb

# Version
VERSION = 1.9.1.9999

GIT_REV=60dc35a48650da02aa33d7b77388775104883119

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

$(SOURCE_ARCHIVE): $(SOURCE_DIR) Makefile MANIFEST
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	mkdir -p $(BUILD_DIR)/tmp
	tar -vxf $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz -C $(BUILD_DIR)/tmp
	mv $(BUILD_DIR)/tmp/$(NAME)-$(GIT_REV)/* $(SOURCE_DIR)
	rm -rf $(BUILD_DIR)/tmp
	rm -f $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	$(SOURCE_TAR_CMD)

# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
