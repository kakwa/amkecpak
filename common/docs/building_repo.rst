Build the complete repositories
-------------------------------

Repository metadata
===================

The repository has a few parameters which must be filled in **common/buildenv/Makefile.config**:

.. sourcecode:: make

    # Name of the maintainer
    MAINTAINER := Name of the Maintainer
    
    # Email of the maintainer
    MAINTAINER_EMAIL := somebody@example.com
    
    # Origin ID (2 or 3 letters ID of origin)
    PKG_ORG := or
    
    # Origin of the packages (full name)
    PKG_ORIGIN := organization
    
    # The gpg key used to sign the packages
    GPG_KEY := GPG_SIGNKEY
    
    # repo component (main/contrib/non-free/universe/etc)
    DEB_REPO_COMPONENT := main
    
    # Definition of the debian repository configuration
    # "Codename: $(DIST)" and "Components: $(DEB_REPO_COMPONENT)"
    # should not be modified.
    define DEB_REPO_CONFIG
    Origin: $(PKG_ORIGIN)
    Label: $(PKG_ORIGIN)
    Suite: $(DIST)
    Codename: $(DIST)
    Version: 3.1
    Architectures: $(shell dpkg --print-architecture)
    Components: $(DEB_REPO_COMPONENT)
    Description: Repository containing misc packages
    SignWith: $(GPG_KEY)
    endef
    
    export DEB_REPO_CONFIG

Clean before build
==================

Optionally, it's possible to clean everything before building:


.. sourcecode:: bash

    # use KEEP_CACHE=true if you want to keep cached upstream sources
    $ make clean
 

Create the repositories
=======================

.. note:: use -j <number of jobs> to run multiple packaging jobs in parallele


.. note:: use **ERROR=skip** to ignore package build failures when calling **make <pkg>_repo** and keep continuing building the repo.

Build .deb repositories
~~~~~~~~~~~~~~~~~~~~~~~

To build the .deb repository, run:

.. sourcecode:: bash

    # Creating the deb repository (using chroots)
    # Replace stretch by the distro code name targeted
    $ make deb_repo -j 4 DIST=stretch 
    
    # Building without chroot, directly on the host
    $ make deb_repo -j 4 DIST=stretch NOCHROOT=true

    # same ignoring individual package build errors
    $ make deb_repo -j 4 DIST=stretch NOCHROOT=true SKIP=true

.. note::

    **deb_repo** target supports the same variables as the **deb_chroot** target, like for example **DEB_MIRROR**


result:

.. sourcecode:: bash
    out
    ├── deb.jessie
    │   ├── conf
    │   │   └── distributions
    │   ├── db
    │   │   ├── checksums.db
    │   │   ├── contents.cache.db
    │   │   ├── packages.db
    │   │   ├── references.db
    │   │   ├── release.caches.db
    │   │   └── version
    │   ├── dists
    │   │   └── jessie
    │   │       ├── InRelease
    │   │       ├── main
    │   │       │   └── binary-amd64
    │   │       │       ├── Packages
    │   │       │       ├── Packages.gz
    │   │       │       └── Release
    │   │       ├── Release
    │   │       └── Release.gpg
    │   ├── pool
    │   │   └── main
    │   │       ├── c
    │   │       │   └── civetweb
    │   │       │       ├── civetweb_1.9.1.9999-2~kw+deb8_amd64.deb
    │   │       │       ├── libcivetweb_1.9.1.9999-2~kw+deb8_amd64.deb
    │   │       │       └── libcivetweb-dev_1.9.1.9999-2~kw+deb8_all.deb
    │   │       ├── p
    │   │       │   ├── pixiecore
    │   │       │   │   └── pixiecore_0.0~2016.02.29-1~kw+deb8_amd64.deb
    │   │       │   ├── python-asciigraph
    │   │       │   │   └── python-asciigraph_1.1.3-1~kw+deb8_all.deb
    │   │       │   ├── python-pygraph-redis
    │   │       │   │   └── python-pygraph-redis_0.2.1-1~kw+deb8_all.deb
    │   │       │   └── python-rfc3161
    │   │       │       └── python-rfc3161_1.0.7-1~kw+deb8_all.deb
    │   │       └── u
    │   │           └── uts-server
    │   │               └── uts-server_0.1.9-1~kw+deb8_amd64.deb
    │   └── raw
    │       ├── civetweb_1.9.1.9999-2~kw+deb8_amd64.deb
    │       ├── Packages
    │       ├── pixiecore_0.0~2016.02.29-1~kw+deb8_amd64.deb
    │       ├── python-asciigraph_1.1.3-1~kw+deb8_all.deb
    │       ├── python-pygraph-redis_0.2.1-1~kw+deb8_all.deb
    │       ├── python-rfc3161_1.0.7-1~kw+deb8_all.deb
    │       ├── uts-server_0.1.9-1~kw+deb8_amd64.deb
    │       └── uts-server-dbgsym_0.1.9-1~kw+deb8_amd64.deb
    └── GPG-KEY.pub


Build the rpm repository
~~~~~~~~~~~~~~~~~~~~~~~~

.. sourcecode:: bash

    # create the rpm repository
    $ make rpm_repo -j 4
    
Result repositories
~~~~~~~~~~~~~~~~~~~

The resulting repositories will look like that:

.. sourcecode:: none

    out
    └── rpm
        └── debU
            └── x86_64
                ├── repodata
                │   ├── 454e22ec768a30aa8e0c169454729501bbcd60f4365ce920d8125f2f4692d987-primary.xml.gz
                │   ├── 8f0383e61bd158979fd85db8a8e26a269b65f2327b183f99ba5139b559dd0336-other.xml.gz
                │   ├── a91c0afbd9bfef2cfb0a00fb3fe5a7490520dbf6d55ea098826cc6f253354552-other.sqlite.bz2
                │   ├── b49576332c4b8277aa173f57ee86b94db25edf2790e5712a39f22044c4c31669-filelists.xml.gz
                │   ├── b7cc2998becaa1b7c4592c3fa81fe5eca4bb522726d8634362cf2054ef01fae2-filelists.sqlite.bz2
                │   ├── e6e5b087813b07eef01de6cbfa9df8ec496affb79141cef026c28a812096dd4b-primary.sqlite.bz2
                │   └── repomd.xml
                └── RPMS
                    ├── dwm-desktop-5.9.0-1.debU.x86_64.rpm
                    ├── gogs-0.7.22-1.debU.x86_64.rpm
                    ├── mksh-skel-1.0.0-1.debU.noarch.rpm
                    ├── python-asciigraph-1.1.3-1.debU.noarch.rpm
                    ├── python-dnscherry-0.1.3-1.debU.noarch.rpm
                    ├── python-ldapcherry-0.2.2-1.debU.noarch.rpm
                    ├── python-ldapcherry-ppolicy-cracklib-0.1.0-1.debU.noarch.rpm
                    └── python-pygraph-redis-0.2.1-1.debU.noarch.rpm

