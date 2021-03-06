# Name of the package
NAME = pixiecore

# Version
VERSION=0.0~2016.02.29
REVISION=fc0d895c19e7c6a31f9d3b8ad5c8967d7285ef87

#VERSION_bufio.v1=v1

VERSION_x_crypto=beef0f4390813b96e8e68fd78570396d0f4751fc
VERSION_x_net=b092070472000b3147a7bdaf7cfc9515cf90514f

VERSION_tinycorelinux=6.4
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

TCL_URL=http://tinycorelinux.net/6.x/x86/archive/$(VERSION_tinycorelinux)/distribution_files/

LICENSE=GPLv2

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

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/$(NAME)-$(REVISION).tar.gz
	mkdir -p $(BUILD_DIR)/tmp
	tar -vxf $(BUILD_DIR)/$(NAME)-$(REVISION).tar.gz -C $(BUILD_DIR)/tmp
	mv $(BUILD_DIR)/tmp/$(NAME)-$(REVISION)/* $(SOURCE_DIR)
	$(GODEPS)
	mkdir -p $(BUILD_DIR)/src/externals/src/github.com/danderson/
	ln -s ../../../../ $(BUILD_DIR)/src/externals/src/github.com/danderson/pixiecore
	mv $(BUILD_DIR)/src/externals $(SOURCE_DIR)/
	rm -rf $(BUILD_DIR)/tmp
	rm -f $(BUILD_DIR)/$(NAME)-$(REVISION).tar.gz
	$(SOURCE_TAR_CMD)



src_prepare_rpm: prepare_deps
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/pixiecore-$(REVISION).tar.gz
	$(WGS) -u $(TCL_URL)/vmlinuz -o $(BUILD_DIR)/src/vmlinuz
	$(WGS) -u $(TCL_URL)/core.gz -o $(BUILD_DIR)/src/core.gz
	mkdir -p $(BUILD_DIR)/src/externals/src/github.com/danderson/
	ln -s ../../../../ $(BUILD_DIR)/src/externals/src/github.com/danderson/pixiecore
	tar -xf $(BUILD_DIR)/pixiecore-$(REVISION).tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/pixiecore-$(REVISION)/* $(BUILD_DIR)/src/
	rm -rf $(BUILD_DIR)/pixiecore-$(REVISION)/
	rm -f $(BUILD_DIR)/pixiecore-$(REVISION).tar.gz

# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
