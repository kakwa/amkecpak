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
    $ cd python-asciigraph/pkg/

    # optionnally, clean cache/ and out/ directory
    $ make clean
 
Build rpm package
=================

Example with with package python-asciigraph:

.. sourcecode:: bash

    # go inside the component directory
    $ cd python-asciigraph/pkg/
   
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

Build deb package
=================

Example with with package python-asciigraph:

.. sourcecode:: bash

    # go inside the component directory
    $ cd python-asciigraph/pkg/
    
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

