# Name of the package
NAME = mattermost

# Version
VERSION = 3.2.0

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/mattermost/platform

# short summary of what the package provides
SUMMARY="Not a package summary"

#VERSION_
VERSION_github.com/mattermost/rsc=bbaefb05eaa0389ea712340066837c8ce4d287f9
VERSION_github.com/alecthomas/log4go=e5dc62318d9bd58682f1dceb53a4b24e8253682f
VERSION_github.com/dgryski/dgoogauth=96977cbd42e27be71f9f731db6634123de7e861a
VERSION_github.com/go-ldap/ldap=537128fee7cca108d8ce74e4309fdfcdd9c7f496
VERSION_gopkg.in/asn1-ber.v1=4e86f4367175e39f69d9358a5f17b4dda270378d


# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/archive/v$(VERSION).tar.gz

# Including common rules and targets 
include buildenv/Makefile.common

# preparation hook for rpm package
# source archives must recovered here
# and their content put inside $(BUILD_DIR)/src
#
# $(WGS) should be the prefered way to recover archives
# (add checksum against a manifest file).
# use 'make manifest' to generate/update this manifest file.

GO_EXT=./buildenv/go_extract.sh -d $(BUILD_DIR)/src/externals/

include Makefile.meta
include Makefile.get

src_prepare_rpm: prepare_deps
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/mattermost-$(VERSION).tar.gz
	tar -vxf $(BUILD_DIR)/mattermost-$(VERSION).tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/platform-$(VERSION)/* $(BUILD_DIR)/src/
	ln -s ../../../../ $(BUILD_DIR)/src/externals/src/github.com/mattermost/platform
	rm -rf $(BUILD_DIR)/platform-$(VERSION)
	rm -f $(BUILD_DIR)/mattermost-$(VERSION).tar.gz


# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
