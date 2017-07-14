# Name of the package
NAME = ldapcherry-ppolicy-cracklib

# Version
VERSION = 0.1.0

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/kakwa/ldapcherry-ppolicy-cracklib

# short summary of what the package provides
SUMMARY="cracklib ppolicy module for ldapcherry"

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

URL_SRC=$(URL)/archive/$(VERSION).tar.gz

###############################################################################
# Rule #
########

# Including common rules and targets 
include buildenv/Makefile.common

# preparation hook for rpm package
# source archives must recovered here
# and their content put inside $(BUILD_DIR)/src
#
# $(WGS) should be the prefered way to recover archives
# (add checksum against a manifest file).
# use 'make manifest' to generate/update this manifest file.

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
	$(WGS) -u $(URL_SRC) -o $(SOURCE_ARCHIVE)
