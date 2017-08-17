Build a package
---------------

Cleaning cache, out and src-out directories
===========================================

Example with with package python-asciigraph:

.. sourcecode:: bash

    # go inside the component directory
    $ cd python-asciigraph

    # clean everything
    $ make clean

    # clean, but keep upstream sources to avoid re-downloading them
    $ make clean KEEP_CACHE=true
 
Build rpm package
=================

Example with package python-asciigraph:

.. sourcecode:: bash

    # go inside the component directory
    $ cd python-asciigraph

    # build rpm package
    $ make rpm
    
Here are the results:

.. sourcecode:: bash

    # output packages:
    $ ls out/
    python-asciigraph-1.1.3-1.kw+unk0.noarch.rpm 
    
    # output source package
    $ ls src-out/
    python-asciigraph-1.1.3-1.kw+unk0.src.rpm

Build rpm inside a clean chroot
===============================

.. warning::

     Not implemented yet

Build deb package
=================

Example with package python-asciigraph:

.. sourcecode:: bash

    # go inside the component directory
    $ cd python-asciigraph
    
    # build deb package
    $ make deb
    
Here are the results:

.. sourcecode:: bash

    # output packages:
    $ ls out/
    python-asciigraph_1.1.3-1~kw+unk0_all.deb 
    
    # output source package
    $ ls src-out/
    python-asciigraph_1.1.3-1~kw+unk0.debian.tar.xz  python-asciigraph_1.1.3-1~kw+unk0.dsc 
    python-asciigraph_1.1.3.orig.tar.gz

Build deb package inside a clean chroot
=======================================

This build system can leverage cowbuilder from Debian to build in a clean chroot.

This is the recommended way to build packages targeted to be used in production.

Building in chroot is heavier but has multiple gains:

* It permits to build in a clean environment every time
* It rapidly exits in error if the build dependencies are not properly declared
* It permits to target different version of Debian (stretch, jessie, wheezy)
* It manages build dependencies, installing them automatically (if properly declared)
* It permits to avoid having to install all build dependencies on your main system


.. sourcecode:: bash

   # go inside the component directory
   $ cd python-asciigraph

   # build deb package for dist jessie
   $ make deb_chroot DIST=jessie

.. note::

    Building the chroot can be a long and heavy step but there are several way to accelerate it.

    The first is to used a local mirror, this can be done using the DEB_MIRROR option when calling deb_chroot:

    .. sourcecode:: bash
        
        make deb_chroot DEB_MIRROR=http://your.local.mirror/debian

    The second is to use a tmpfs for building, it requires a few GB of RAM however (at least 1.5GB per distro
    version targeted, but this may vary depending on the number packages and the size of their dependencies):

    .. sourcecode:: bash

        # as root
        mount -t tmpfs -o size=16G tmpfs /var/cache/pbuilder/

    .. sourcecode:: bash

        # in fstab
        tmpfs /var/cache/pbuilder/ tmpfs defaults,size=16G 0 0

.. warning::

    If there is an issue or when modifying the chroot (changing the mirror used for example),
    it may be necessary to removing an existing cowbuilder chroot.

    For that, use the **deb_get_chroot_path** target:

    .. sourcecode:: bash

        
        # show the chroot path:
        make deb_get_chroot_path DIST=<code name>

        # as root
        # remove the chroot
        rm -rf `make deb_get_chroot_path DIST=<code name>`

.. warning::

    Some recent distributions may disable the **vsyscall** syscall which is used by older libc (ex: CentOS/RHEL <= 6).

    The problem can be diagnosed by running **dmesg** after a failure to create or run anything in the chroot. You
    would get errors like:

    .. sourcecode:: bash

        [  578.456176] sh[15402]: vsyscall attempted with vsyscall=none ip:ffffffffff600400 cs:33 sp:7ffd469c5aa8 ax:ffffffffff600400 si:7ffd469c6f23 di:0
        [  578.456180] sh[15402]: segfault at ffffffffff600400 ip ffffffffff600400 sp 00007ffd469c5aa8 error 15

    In most cases this syscall can be reenabled with **vsyscall=emulate** option in the kernel command line.


.. warning::

    To create the cowbuilder chroot, it's required to have the GPG keys of the targeted DIST.

    If you get errors like:

    .. sourcecode:: bash

        I: Checking Release signature
        E: Release signed by unknown key (key id EF0F382A1A7B6500)
        E: debootstrap failed

    it means that you don't have the required keys.

    The debian-archive-keyring and ubuntu-archive-keyring packages provides these keys. However
    it might be necessary to use a newer keyring than the one available in your environment, specially
    if crossing from an old Ubuntu to a new Debian or an old Debian to a new Ubuntu.

    For example, with Ubuntu Trusty (14.04), targeting Debian stretch, the following hack is necessary:

    .. sourcecode:: bash

        wget http://cz.archive.ubuntu.com/ubuntu/pool/universe/d/debian-archive-keyring/debian-archive-keyring_2017.5_all.deb \
                && sudo dpkg -i debian-archive-keyring_2017.5_all.deb

        ls /etc/apt/trusted.gpg.d/
        debian-archive-jessie-automatic.gpg           debian-archive-stretch-security-automatic.gpg
        debian-archive-jessie-security-automatic.gpg  debian-archive-stretch-stable.gpg
        debian-archive-jessie-stable.gpg              debian-archive-wheezy-automatic.gpg
        debian-archive-stretch-automatic.gpg          debian-archive-wheezy-stable.gpg

    It might also be necessary to pass additionnal parameters to make cowbuilder use this keyring:

    .. sourcecode:: bash

        make deb_chroot DIST=stretch COW_OPTS=--debootstrapopts=--keyring=/etc/apt/trusted.gpg.d/debian-archive-stretch-stable.gpg

.. warning::

    Building in chroot requires root permission (it's necessary for creating the chroot environment).

    If **make deb_chroot** is run as a standard user, **sudo** will be used for cowbuilder calls.

    If you want to avoid password promt, the only command that needs to be white listed
    in sudoers configuration is **cowbuilder**:

    .. sourcecode:: bash

        # replace build-user with the user used to generate the packages
        build-user ALL=(ALL) NOPASSWD: /usr/sbin/cowbuilder
