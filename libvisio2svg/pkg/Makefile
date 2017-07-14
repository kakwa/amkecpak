# Name of the package
NAME = libvisio2svg

# Version
VERSION = 0.4.0

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/kakwa/libvisio2svg

# short summary of what the package provides
SUMMARY="visio to SVG conversion library"

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/archive/$(VERSION).tar.gz

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
