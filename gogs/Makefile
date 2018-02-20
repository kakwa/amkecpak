# Name of the package
NAME = gogs

# Version
VERSION = 0.11.34

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/gogits/gogs

# short summary of what the package provides
SUMMARY=Gogs (Go Git Service) is a painless self-hosted Git service.

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

LICENSE=MIT

###############################################################################
# Rule #
########

GH=https://github.com/

# example of source recovery url
URL_SRC=$(URL)/archive/v$(VERSION).tar.gz

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

#$(GODEPS)

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST src/gogs.ini
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	mkdir -p $(BUILD_DIR)/tmp
	tar -vxf $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz -C $(BUILD_DIR)/tmp
	mv $(BUILD_DIR)/tmp/$(NAME)-$(VERSION)/* $(SOURCE_DIR)
	cp src/gogs.ini $(SOURCE_DIR)
	mkdir -p $(SOURCE_DIR)/externals/src/
	mv $(SOURCE_DIR)/vendor/* $(SOURCE_DIR)/externals/src/
	mkdir -p $(SOURCE_DIR)/externals/src//github.com/gogits/
	ln -s ../../../../ $(SOURCE_DIR)/externals/src/github.com/gogits/gogs
	rm -rf $(BUILD_DIR)/tmp/vendor 
	rm -rf $(BUILD_DIR)/tmp
	rm -f $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	$(SOURCE_TAR_CMD)

# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
