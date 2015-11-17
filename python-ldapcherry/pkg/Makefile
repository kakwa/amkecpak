# Name of the package
NAME = python-ldapcherry

# Version (idem)
VERSION = 0.2.2

# release number 
RELEASE = 1

# external url where to recover the sources
URL=https://github.com/kakwa/ldapcherry/archive/$(VERSION).tar.gz

###############################################################################
# Rules #
#########

# Including common rules
include buildenv/Makefile.common

# preparation hook for rpm 
src_prepare_rpm:
	$(WGS) -u $(URL) -o $(BUILD_DIR)/lc.tar.gz
	tar -vxf $(BUILD_DIR)/lc.tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/ldapcherry-$(VERSION)/* $(BUILD_DIR)/src/
	rm -rf ldapcherry-$(VERSION)
	rm -f $(BUILD_DIR)/lc.tar.gz

# preparation hook for deb (same as rpm  by default)
src_prepare_deb: src_prepare_rpm
