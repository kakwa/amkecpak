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

.. note:: this framework handles build dependencies needing themself to be built.

    This is done by a simple retry loop: if packages fails to build, retry with the freeshly generated packages available as installable dependencies.
    
    This should converge to all packages being built. It will stop in error if an iterration doesn't manage to build any new package.

Build .deb repository
~~~~~~~~~~~~~~~~~~~~~

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


Result:

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

To build the .rpm repository, run:

.. sourcecode:: bash

    # Create the rpm repository
    # Replace el7 by the distro code name targeted
    $ make rpm_repo DIST=el7
    

.. warning::

    mock doesn't support building 2 packages in parallele, don't use -j N with N > 1.

The resulting repositories will look like that:

.. sourcecode:: none

    out
    ├── GPG-KEY.pub
    └── rpm.el7
        ├── 7
        │   └── x86_64
        │       ├── civetweb-1.9.1.9999-3.el7.centos.x86_64.rpm
        │       ├── dnscherry-0.1.3-1.el7.centos.noarch.rpm
        │       ├── python-asciigraph-1.1.3-1.el7.centos.noarch.rpm
        │       ├── python-pygraph-redis-0.2.1-1.el7.centos.noarch.rpm
        │       ├── python-rfc3161-1.0.7-1.el7.centos.noarch.rpm
        │       ├── repodata
        │       │   ├── 279156abfa1a5611056b66b7b6481e531977699ee9b5b06462fc58848408cb88-filelists.xml.gz
        │       │   ├── 3221e073b2d2d0a4176d591db070b479975e1341336a96e1c3507366743e4969-other.sqlite.bz2
        │       │   ├── a718d20219a56321fb7c981944d671a6ab79379f064388a5bad4ec9f0d2e6b39-other.xml.gz
        │       │   ├── ab2d5c7943cb6fea596116dc841be8da02f5057903b8e4314de9f302cd20e59f-primary.xml.gz
        │       │   ├── ec4c86e1cf1c6e36c8020b650066db23c112f2357803eb8dfc327aff8197e2c2-filelists.sqlite.bz2
        │       │   ├── fbc3d4f1d6831239ca0a138e24dcbb6ed5b08f5521bae5c5c41d0e46f56e34b2-primary.sqlite.bz2
        │       │   └── repomd.xml
        │       └── uts-server-0.1.9-1.el7.centos.x86_64.rpm
        └── raw
            ├── configs
            │   └── epel-7-x86_64
            │       ├── epel-7-x86_64.cfg
            │       ├── logging.ini
            │       └── site-defaults.cfg
            └── results
                └── epel-7-x86_64
                    ├── civetweb-1.9.1.9999-3.kw+el7
                    │   ├── build.log
                    │   ├── civetweb-1.9.1.9999-3.el7.centos.src.rpm
                    │   ├── civetweb-1.9.1.9999-3.el7.centos.x86_64.rpm
                    │   ├── libcivetweb-1.9.1.9999-3.el7.centos.x86_64.rpm
                    │   ├── libcivetweb-devel-1.9.1.9999-3.el7.centos.x86_64.rpm
                    │   ├── root.log
                    │   ├── state.log
                    │   └── success
                    ├── python-asciigraph-1.1.3-1.kw+el7
                    │   ├── build.log
                    │   ├── python-asciigraph-1.1.3-1.el7.centos.noarch.rpm
                    │   ├── python-asciigraph-1.1.3-1.el7.centos.src.rpm
                    │   ├── root.log
                    │   ├── state.log
                    │   └── success
                    ├── python-pygraph-redis-0.2.1-1.kw+el7
                    │   ├── build.log
                    │   ├── python-pygraph-redis-0.2.1-1.el7.centos.noarch.rpm
                    │   ├── python-pygraph-redis-0.2.1-1.el7.centos.src.rpm
                    │   ├── root.log
                    │   ├── state.log
                    │   └── success
                    ├── python-rfc3161-1.0.7-1.kw+el7
                    │   ├── build.log
                    │   ├── python-rfc3161-1.0.7-1.el7.centos.noarch.rpm
                    │   ├── python-rfc3161-1.0.7-1.el7.centos.src.rpm
                    │   ├── root.log
                    │   ├── state.log
                    │   └── success
                    ├── repodata
                    │   ├── 21289fde781204ae80d8b5ccb6409f15298f3d131c5d9b6c83a559023d66117b-primary.sqlite.bz2
                    │   ├── 4a058e025303cbaa07d36b869cfa275d3c34eb8d8ce03b973544f449185b6971-primary.xml.gz
                    │   ├── 64b282083531afc79e552b977c591e381cded3ace188e35a12f922b6f63e9bd3-filelists.xml.gz
                    │   ├── 9efa0da5d3d74511206cfba49adca7179bcd13bf9e48bb39582cce9e4ccdc1a6-filelists.sqlite.bz2
                    │   ├── bb3775aea68d9c6de66a7d466d0af65f0e19a4d0e036cf6df341f2d7f56c16dd-other.xml.gz
                    │   ├── c22678232ad81e43413ccc4e5ac8a3966b7ea70697b499b35dd4c9ad457386fa-other.sqlite.bz2
                    │   ├── filelists.xml.gz
                    │   ├── other.xml.gz
                    │   └── repomd.xml
                    └── uts-server-0.1.9-1.kw+el7
                        ├── build.log
                        ├── root.log
                        ├── state.log
                        ├── success
                        ├── uts-server-0.1.9-1.el7.centos.src.rpm
                        └── uts-server-0.1.9-1.el7.centos.x86_64.rpm
    
