Required tools
--------------

This packaging infrastructure relies on few basic tools.

.. note::
    
    Debian has all the necessary tooling build rpm and create the rpm repo.
    However CentOS doesn't have the debian tooling.

.. warning::

    What is detailed here is only the common tools used to build packages and repo.
    For each package, you need to install its own build dependancies (stuff like gcc, python-setuptools, etc).

Debian/Ubuntu tools
===================

To install the Debian requirements:

.. sourcecode:: bash

    # Debian/Ubuntu (deb)
    $ apt-get install make debhelper reprepro lsb-release rsync cowbuilder

RHEL/CentOS/Fedora tools
========================

To install the RHEL requirements:

.. sourcecode:: bash

    # CentOS/RHEL (rpm)
    $ yum install rpm-sign expect rpm-build createrepo rsync make mock

    # Fedora (rpm)
    $ dnf install rpm-sign expect rpm-build createrepo rsync make mock

