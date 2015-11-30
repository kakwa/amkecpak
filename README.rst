Packages
========

Stuff I package for fun and profit.

.. .. image:: https://travis-ci.org/kakwa/packages.svg?branch=master
..    :target: https://travis-ci.org/kakwa/packages
    
.. image:: https://readthedocs.org/projects/kakwa-packages/badge/?version=latest
    :target: http://kakwa-packages.readthedocs.org/en/latest/?badge=latest
    :alt: Documentation Status

----

:Doc:    `Documentation on ReadTheDoc <http://kakwa-packages.readthedocs.org/en/latest/>`_
:Dev:    `GitHub <https://github.com/kakwa/packages>`_
:Author:  Pierre-Francois Carpentier - copyright © 2015

----


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

    # gpg key generation (one time thing)
    $ gpg --gen-key

    # Preparing the repositories metadata
    $ vim Makefile

    # Building the repositories
    $ make deb_repo -j 4
    $ make rpm_repo -j 4

If you need more information, read the `detailed documentation <http://kakwa-packages.readthedocs.org/en/latest/>`_.
