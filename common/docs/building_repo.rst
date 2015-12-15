Build the complete repositories
-------------------------------

Repository metadata
===================

The repository has a few metadata which must be filled:

.. sourcecode:: make

    # Name of the gpg key to use
    GPG_KEY="kakwa"
    # Output directory for the repos
    OUTPUT="out/"
    # Package provider
    ORIGIN="kakwa"

Clean before build
==================

Optionnally, it's possible to clean everything before build:


.. sourcecode:: bash

    # optionnally, cleaning everything
    $ make clean
 

Create the repositories
=======================

To build the repositories, just run:

.. note:: use -j <number of jobs> to run multiple packaging jobs in parallele


.. note:: use ERROR=skip in **make <pkg>_repo** to ignore package build failures and continue building the repo

Build deb repository
~~~~~~~~~~~~~~~~~~~~

.. sourcecode:: bash

    # create the deb repository
    $ make deb_repo -j 4
    
    # create everything
    $ make all -j 4

Build the rpm repository
~~~~~~~~~~~~~~~~~~~~~~~~

.. sourcecode:: bash

    # create the rpm repository
    $ make rpm_repo -j 4
    
Create both repo in one command
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. sourcecode:: bash

    # create everything
    $ make all -j 4

Result repositories
~~~~~~~~~~~~~~~~~~~

The resulting repositories will look like that:

.. sourcecode:: none

    out
    ├── deb
    │   └── sid
    │       └── amd64
    │           ├── conf
    │           │   └── distributions
    │           ├── db
    │           │   ├── checksums.db
    │           │   ├── contents.cache.db
    │           │   ├── packages.db
    │           │   ├── references.db
    │           │   ├── release.caches.db
    │           │   └── version
    │           ├── dists
    │           │   └── sid
    │           │       └── contrib
    │           │           └── binary-amd64
    │           └── pool
    │               └── contrib
    │                   ├── d
    │                   │   └── dwm-desktop
    │                   │       └── dwm-desktop_5.9.0-1_amd64.deb
    │                   ├── g
    │                   │   └── gogs
    │                   │       └── gogs_0.7.22-1_amd64.deb
    │                   ├── m
    │                   │   └── mksh-skel
    │                   │       └── mksh-skel_1.0.0-1_all.deb
    │                   └── p
    │                       ├── python-asciigraph
    │                       │   └── python-asciigraph_1.1.3-1_all.deb
    │                       ├── python-dnscherry
    │                       │   └── python-dnscherry_0.1.3-1_all.deb
    │                       ├── python-ldapcherry
    │                       │   └── python-ldapcherry_0.2.2-1_all.deb
    │                       ├── python-ldapcherry-ppolicy-cracklib
    │                       │   └── python-ldapcherry-ppolicy-cracklib_0.1.0-1_all.deb
    │                       └── python-pygraph-redis
    │                           └── python-pygraph-redis_0.2.1-1_all.deb
    ├── pub.gpg
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

