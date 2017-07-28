Amkecpak, a makefile based packaging framework.

.. image:: https://travis-ci.org/kakwa/amkecpak.svg?branch=master
   :target: https://travis-ci.org/kakwa/amkecpak
    
.. image:: https://readthedocs.org/projects/amkecpak/badge/?version=latest
    :target: http://amkecpak.readthedocs.org/en/latest/?badge=latest
    :alt: Documentation Status

----

:Doc:    `Documentation on ReadTheDoc <http://amkecpak.readthedocs.org/en/latest/>`_
:Dev:    `GitHub <https://github.com/kakwa/amkecpak>`_
:Author:  Pierre-Francois Carpentier - copyright © 2017

----


Packaging documentation in a nutshell
-------------------------------------

.. sourcecode:: bash
    
    # Install the packaing tools
    $ apt-get install make debhelper reprepro
    # or
    $ yum install rpm-sign expect rpm-build createrepo make

    # Init a package foo
    $ ./common/init_pkg.sh -n foo

    $ cd foo/

    # Implementing the package
    $ vim Makefile
    $ vim debian/rules ; vim debian/control
    $ vim rpm/component.spec

    # Help for the various targets
    $ make help

    # Building the packages
    $ make deb
    $ make rpm

    $ cd ../

    # gpg key generation (one time thing)
    $ gpg --gen-key

    # Building the repositories
    # Use ERROR=skip to ignore package build failures and continue building the repo
    $ make deb_repo -j 4 # ERROR=skip
    $ make rpm_repo -j 4 # ERROR=skip

If you need more information, read the `detailed documentation <http://amkecpak.readthedocs.org/en/latest/>`_.
