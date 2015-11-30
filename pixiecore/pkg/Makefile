# Name of the package
NAME = pixiecore

# Version
VERSION=0.0.2015.10.22
REVISION=b9a4006784aec6400b161a214cc16514c0f65900

#VERSION_bufio.v1=v1

VERSION_x_crypto=beef0f4390813b96e8e68fd78570396d0f4751fc
VERSION_x_net=b092070472000b3147a7bdaf7cfc9515cf90514f

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/danderson/pixiecore/

# short summary of what the package provides
SUMMARY=PXE booting for people in a hurry.

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

###############################################################################
# Rule #
########

GH=https://github.com/

# example of source recovery url
URL_SRC=$(URL)/archive/$(REVISION).tar.gz

GO_EXT=./buildenv/go_extract.sh -d $(BUILD_DIR)/src/externals/

# Including common rules and targets 
include buildenv/Makefile.common

# preparation hook for rpm package
# source archives must recovered here
# and their content put inside $(BUILD_DIR)/src
#
# $(WGS) should be the prefered way to recover archives
# (add checksum against a manifest file).
# use 'make manifest' to generate/update this manifest file.

include Makefile.meta
include Makefile.get

src_prepare_rpm: prepare_deps
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/pixiecore-$(REVISION).tar.gz
	mkdir -p $(BUILD_DIR)/src/externals/src/github.com/danderson/
	ln -s ../../../../ $(BUILD_DIR)/src/externals/src/github.com/danderson/pixiecore
	tar -xf $(BUILD_DIR)/pixiecore-$(REVISION).tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/pixiecore-$(REVISION)/* $(BUILD_DIR)/src/
	rm -rf $(BUILD_DIR)/pixiecore-$(REVISION)/
	rm -f $(BUILD_DIR)/pixiecore-$(REVISION).tar.gz

# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
