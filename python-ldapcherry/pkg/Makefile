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
VERSION = 0.0.1

# numero de revision
RELEASE = 1


###############################################################################
# Règles #
##########

# Inclusion des règles communes à tous les composants
include buildenv/Makefile.common

# hook de manipulation des sources pour rpm
src_prepare_rpm:
#exemple de recuperation d'un tar de sources externes
#       cd $(BUILD_DIR)/src;\
#       wget $(RESSOURCE_SERVER)/$(NAME)/$(VERSION)/<name>.tar.gz;\
#       tar xf $(NAME)-$(VERSION).tar.gz;\
#       rm $(NAME)-$(VERSION).tar.gz

#exemple de recuperation d'un logiciel avec beaucoup de fichiers
#       cd $(BUILD_DIR)/src;\
#       wget $(RESSOURCE_SERVER)/$(NAME)/$(VERSION)/listing;\
#       for f in `cat listing`;do wget $(RESSOURCE_SERVER)/$(NAME)/$(VERSION)/$f;done



# hook de manipulation des sources pour deb
# * s'il est identique au rpm, on fait la meme chose
# * s'il est different supprime "src_prepare_rpm"
# 	et rajoutez les commandes adhoc	
src_prepare_deb: src_prepare_rpm

