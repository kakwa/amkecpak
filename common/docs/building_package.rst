Build a package
---------------

To build a package **foo**, just go in **foo/pkg** directory and run **make deb** and/or **make rpm**.

The resulting package(s) are located in the **out** directory. 
Source package(s) are in the **src-out** directory.

Cleaning cache, out and src-out directories
===========================================

Example with with package python-asciigraph:

.. sourcecode:: bash

    # go inside the component directory
    $ cd python-asciigraph

    # optionnally, clean cache/ and out/ directory
    $ make clean
 
Build rpm package
=================

Example with with package python-asciigraph:

.. sourcecode:: bash

    # go inside the component directory
    $ cd python-asciigraph
   
    # build rpm package
    $ make rpm
    
Here are the results:

.. sourcecode:: bash

    # output packages:
    $ ls out/
    python-asciigraph-1.1.3-1.unk.noarch.rpm
    
    # output source package
    $ ls src-out/
    python-asciigraph-1.1.3-1.unk.src.rpm

Build rpm inside a clean chroot
===============================

Not implemented yet

Build deb package
=================

Example with with package python-asciigraph:

.. sourcecode:: bash

    # go inside the component directory
    $ cd python-asciigraph
    
    # build deb package
    $ make deb
    
Here are the results:

.. sourcecode:: bash

    # output packages:
    $ ls out/
    python-asciigraph_1.1.3-1_all.deb
    
    # output source package
    $ ls src-out/
    python-asciigraph_1.1.3-1.debian.tar.xz  python-asciigraph_1.1.3.orig.tar.gz
    python-asciigraph_1.1.3-1.dsc            

Build deb package inside a clean chroot
=======================================

This build system can leverage cowbuilder from Debian to build in a clean chroot.

This is the recommended way to build packages targeted to be used in production.

Building in chroot is heavier but has multiple gains:

* It permits to build in a clean environment every time
* It rapidely exits in error if the build dependencies are not properly declared
* It permits to target different version of Debian (stretch, jessie, wheezy)
* It manages build dependencies, installing them automatically (if properly declared)
* It permits to avoid having to install all build dependencies on your main system


.. sourcecode:: bash

   # go inside the component directory
   $ cd python-asciigraph

   # build deb package for dist jessie
   $ make deb_chroot DIST=jessie

.. warning::

    Building in chroot requires root permission (it's necessary for creating the chroot environment).
    If make deb_chroot is run as a standard user, sudo will be used for cowbuilder calls.
    The only command that needs to be white listed in sudo is cowbuilder.
