Cheatsheet
----------

Scripts
=======

Initialize a package:

.. sourcecode:: bash

    $ ./common/init_pkg.sh -n <PKG_NAME>

All Makefiles
=============

Display the help:

.. sourcecode:: bash

    $ make help

Listing the the distribution versions available:

.. sourcecode:: bash

    $ make list_dist

Cleaning:

.. sourcecode:: bash

    # clean everything
    $ make clean

    # clean everything except upstream downloads
    $ make clean KEEP_CACHE=true

Package Makefile
================

(Re)creating the MANIFEST file:

.. sourcecode:: bash

    $ make manifest

Building .deb:

.. sourcecode:: bash

    $ make deb

Building .rpm:

.. sourcecode:: bash

    $ make rpm

Building .deb (chroot):

.. sourcecode:: bash

    $ make deb_chroot DIST=<VERSION>

Building .rpm (chroot):

.. sourcecode:: bash

    $ make rpm_chroot DIST=<VERSION>

Global Makefile
===============

Building all .deb:

.. sourcecode:: bash

    $ make deb

Building all .rpm:

.. sourcecode:: bash

    $ make rpm

Building  all.deb (chroot):

.. sourcecode:: bash

    $ make deb_chroot DIST=<VERSION>

Building all .rpm (chroot):

.. sourcecode:: bash

    $ make rpm_chroot DIST=<VERSION>

Building the .deb repository:

.. sourcecode:: bash

    $ make deb_repo DIST<VERSION>

Building the .rpm repository:

.. sourcecode:: bash

    $ make rpm_repo DIST<VERSION>
