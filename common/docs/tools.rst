Requirements
------------

This section details the tools needed by this packaging framework.

.. warning::

    Only the tools necessary for building packages are detailed here.
    Each individual package requires it's own build dependencies (gcc, cmake...).
    You must either install those dependencies or build in chroot (make *rpm_chroot* or *deb_chroot*).

Debian/Ubuntu
=============

To install the Debian requirements:

.. sourcecode:: bash

    # Debian/Ubuntu (deb)
    $ apt-get install make debhelper reprepro cowbuilder wget

Debian/Ubuntu also distributes rpm packaging tools.
Here are the additionnal packages to install if you want to produce rpms on a Debian based system:

.. sourcecode:: bash

    # Debian/Ubuntu (rpm)
    $ apt-get install createrepo rpm mock expect

RHEL/CentOS/Fedora
==================

To install the RHEL requirements:

.. sourcecode:: bash

    # CentOS/RHEL (rpm)
    $ yum install rpm-sign expect rpm-build createrepo make mock wget

    # Fedora (rpm)
    $ dnf install rpm-sign expect rpm-build createrepo make mock wget

.. note::
    
    CentOS/RHEL doesn't distribute the .deb tooling. Contrary to Debian/Ubuntu, it's not
    possible to produce .deb on a CentOS/RHEL.
