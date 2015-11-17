###############################################################################
#
# Règles Makefile spécifiques au composant $module.
#
###############################################################################
# Variables spécifiques #
#########################

# Nom du composant (obligatoire, repris dans les
# règles communes pour construire le nom du paquet)
NAME = python-ldapcherry

# Version (idem)
VERSION = 0.2.2

# numero de revision
RELEASE = 1

URL=https://github.com/kakwa/ldapcherry/archive/$(VERSION).tar.gz

###############################################################################
# Règles #
##########

# Inclusion des règles communes à tous les composants
include buildenv/Makefile.common

# hook de manipulation des sources pour rpm
src_prepare_rpm:
	$(WGS) -u $(URL) -o $(BUILD_DIR)/lc.tar.gz
	tar -vxf $(BUILD_DIR)/lc.tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/ldapcherry-$(VERSION)/* $(BUILD_DIR)/src/
	rm -rf ldapcherry-$(VERSION)
	rm -f $(BUILD_DIR)/lc.tar.gz

src_prepare_deb: src_prepare_rpm
