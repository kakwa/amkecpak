Packages
========

Stuff I package for fun and profit.

Packaging documentation in a nutshell
-------------------------------------

.. sourcecode:: bash

    # Init a package foo
    $ ./common/init_pkg.sh -n foo

    $ cd foo/pkg/

    # Implementing the package
    $ vim Makefile
    $ vim debian/rules ; vim debian/control
    $ vim foo.spec

    # Building the package
    $ make deb
    $ make rpm

    $ cd ../../ 

    # Preparing the repositories metadata
    $ vim Makefile

    # Building the repositories
    $ make deb_repo -j 4
    $ make rpm_repo -j 4
