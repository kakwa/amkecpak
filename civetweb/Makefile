# Name of the package
NAME = civetweb

# Version
VERSION = 1.10

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/civetweb/civetweb

# short summary of what the package provides
SUMMARY=Embedded C/C++ web server

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY), under MIT (Mongoose fork)

LICENSE=MIT

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

$(SOURCE_ARCHIVE): $(SOURCE_DIR) Makefile MANIFEST $(CACHE)
	$(WGS) -u $(URL_SRC) -o $(SOURCE_ARCHIVE)

# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
