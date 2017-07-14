# Name of the package
NAME = python-rfc3161

# Version
VERSION = 1.0.7

# Revision number 
RELEASE = 1

# URL of the project 
URL=http://repos.entrouvert.org/python-rfc3161.git

# short summary of what the package provides
SUMMARY="Python implementation of the RFC3161 specification, using pyasn1"

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/snapshot/python-rfc3161-$(VERSION).tar.gz

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

