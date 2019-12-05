# Name of the package
NAME = drpm

# Version
VERSION = 0.4.1

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/rpm-software-management/drpm

# short summary of what the package provides
SUMMARY=The drpm package provides a library for making, reading and applying deltarpms

# Long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

# License of the upstream project
LICENSE=LGPLv2+

# Distribution versions to skip
#
# format: space separated list of rules.
# each rule have the format "<op>:<dist>:<version>", with:
#   <op>:      the operation (must be  '>', '>=', '<', '<=' or '=')
#   <dist>:    the distribution code name (examples: 'deb', 'el', 'fc')
#   <version>: the version number to ignore
#
SKIP=>=:el:0 >=:fc:0

###############################################################################
# Rule #
########

# example of source recovery url
URL_SRC=$(URL)/archive/$(VERSION).tar.gz

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

# Example of simple recovery, with good upstream
$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
	$(WGS) -u $(URL_SRC) -o $(SOURCE_ARCHIVE)
