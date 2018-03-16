# Name of the package
NAME = uts-server

# Version
VERSION = 0.1.10

# Revision number 
RELEASE = 5

# URL of the project 
URL=https://github.com/kakwa/uts-server/

# short summary of what the package provides
SUMMARY=Micro RFC 3161 Time-Stamp server written in C

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

LICENSE=MIT

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

#src_prepare_rpm: src_prepare_deb
#	cp -r debian/uts-server.tmpfile $(BUILD_DIR)/src/
#	cp -r debian/uts-server.default $(BUILD_DIR)/src/
#	cp -r debian/uts-server.service $(BUILD_DIR)/src/
#	cp -r debian/uts-server.cnf     $(BUILD_DIR)/src/
#	sed -i 's/default/sysconfig/' $(BUILD_DIR)/src/uts-server.service
