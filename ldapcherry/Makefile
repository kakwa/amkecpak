# Name of the package
NAME = ldapcherry

# Version (idem)
VERSION = 1.1.1

# release number 
RELEASE = 1

# external url where to recover the sources
URL=https://github.com/kakwa/ldapcherry

SUMMARY=User directory management web UI

DESCRIPTION=$(SUMMARY)

URL_SRC=$(URL)/archive/$(VERSION).tar.gz

LICENSE=MIT

###############################################################################
# Rules #
#########

# Including common rules
include buildenv/Makefile.common

$(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
	$(WGS) -u $(URL_SRC) -o $(SOURCE_ARCHIVE)

