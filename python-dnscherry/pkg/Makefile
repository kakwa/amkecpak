# Name of the package
NAME = python-dnscherry

# Version (idem)
VERSION = 0.1.2

# release number 
RELEASE = 1

# external url where to recover the sources
URL=https://github.com/kakwa/dnscherry
URL_SRC=$(URL)/archive/$(VERSION).tar.gz

SUMMARY="DNS management web UI"

DESCRIPTION=$(SUMMARY)

###############################################################################
# Rules #
#########

# Including common rules
include buildenv/Makefile.common

# preparation hook for rpm 
src_prepare_rpm:
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/lc.tar.gz
	tar -vxf $(BUILD_DIR)/lc.tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/dnscherry-$(VERSION)/* $(BUILD_DIR)/src/
	rm -rf dnscherry-$(VERSION)
	rm -f $(BUILD_DIR)/lc.tar.gz

# preparation hook for deb (same as rpm  by default)
src_prepare_deb: src_prepare_rpm
