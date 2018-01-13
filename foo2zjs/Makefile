# Name of the package
NAME = foo2zjs

# Version
VERSION = 20171202

# Revision number 
RELEASE = 1

# URL of the project 
URL=http://foo2zjs.rkkda.com/

# short summary of what the package provides
SUMMARY=tools to print to some HP and Minolta/QMS ZjStream printers

# Long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

# License of the upstream project
LICENSE=GPLv2

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=https://mirror.kakwalab.ovh/src/foo2zjs/$(VERSION)/foo2zjs.tar.gz

# Including common rules and targets 
include buildenv/Makefile.common

# preparation hook for sources
# source archive must be recovered here, optionaly reworked, and
# moved to $(SOURCE_ARCHIVE) (the expected path of the source archive for the
# rest of the build)
#
# $(WGS) should be the prefered way to recover archives
# (add checksum against a manifest file).
# use 'make manifest' to generate/update this manifest file.

# more complex case with upstream source rework and rebuilding of the tar
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	mkdir -p $(BUILD_DIR)/tmp
	tar -vxf $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz -C $(BUILD_DIR)/tmp/
	chmod 644 $(BUILD_DIR)/tmp/$(NAME)/INSTALL
	chmod 644 $(BUILD_DIR)/tmp/$(NAME)/README
	chmod 755 $(BUILD_DIR)/tmp/$(NAME)/myftpput
	mv $(BUILD_DIR)/tmp/$(NAME)/* $(SOURCE_DIR)
	rm -rf $(BUILD_DIR)/tmp
	rm -f $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz
	$(SOURCE_TAR_CMD)
