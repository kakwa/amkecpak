Create a package
----------------

Creating a package **foo** involves the following steps:

* Initialize the packaging directories.
* Fill **foo**/Makefile (used for common metadata and upstream source recovery and preparation).
* Do the distribution specific stuff (dependencies in **debian/control** and **foo.spec**,
  pre/post install scripts, init scripts, etc)
* Build the package

Here is the general packaging workflow:

.. figure:: img/pkg_diagram.png
    :scale: 80

* The steps in orange are common for all packages and must not be modified.
* The steps in green are package specific, it's those steps which must be customized for each package.

Initialize package skeleton
===========================

To create a package "foo" skeleton, run the follwing command:

.. sourcecode:: bash

    $ ./common/init_pkg.sh -n foo

This script will create the following tree:

.. sourcecode:: none

    foo
    ├── buildenv -> ../common/buildenv
    ├── debian
    │   ├── changelog
    │   ├── compat
    │   ├── conffiles
    │   ├── control
    │   ├── copyright
    │   ├── foo.cron.d.ex
    │   ├── foo.default.ex
    │   ├── init.d.ex
    │   ├── postinst.ex
    │   ├── postrm.ex
    │   ├── preinst.ex
    │   ├── prerm.ex
    │   ├── rules
    │   └── source
    │       └── format
    ├── rpm
    │   └── component.spec
    ├── Makefile
    └── MANIFEST

This tree contains two main directories, two main files, and a symlink:

* **debian**: deb packaging stuff.
* **rpm**: rpm packaging stuff (**component.spec** and optionally additional content like **.service** files).
* **Makefile**: used to download and prepare upstream sources.
* **MANIFEST**: listing the downloaded files and their hash.
* **buildenv**: symlink to the shared build resources (Makefile.common, and various helper scripts).

.. note:: Don't rename component.spec, build script for rpm expect this file to exist.

At this point, with default content, "empty" .rpm and .deb packages can be built:

.. sourcecode:: bash

    $ cd foo/   # go in dir
    # make help # display Makefile help
    $ make deb  # build deb
    $ make rpm  # build rpm
    $ dpkg -c out/foo_0.0.1-1\~up+deb00_all.deb # look .deb content
    $ rpm -qpl out/foo-0.0.1-1.00.noarch.rpm    # look .rpm content

Package metadata
================

It's necessary to setup the package metadata (version, description) to their proper values. Package metadata are declared at the top of the package Makefile:

.. sourcecode:: make

    # Version
    # if possible, keep the upstream version
    VERSION=0.0.1
    
    # Revision number
    # increment it when fixing packaging for a given release
    # reset it to 1 if VERSION is increased
    RELEASE=1
    
    # URL of the upstream project
    URL=http://example.org/stuff
    
    # short summary of what the package provides
    SUMMARY=My package summary
    
    # long version of the summary, (but I could be lazy)
    DESCRIPTION=$(SUMMARY)

.. note::

    During the package build, these variables are automatically substitute in packaging files. 
    This is done by simple running sed -s 's|@VAR@|$(VAR)|' on these files.

    Don't remove the @VAR@ (ex: @SUMMARY@, @URL@, @VERSION@) in the packaging files.

Download upstream sources
=========================

This packaging infrastructure comes with a small tool, **./common/buildenv/wget_sum.sh** to handle downloads.

This tool role is:

* Download upstream sources.
* Check the integrity of the upstream source against the *MANIFEST* file (sha512 sum).
* (Re)Build the *MANIFEST* file if requested.
* Handle a local download cache to avoid downloading sources at each build.

Download tool usage
~~~~~~~~~~~~~~~~~~~

Inside the Makefile, use it as followed:

.. sourcecode:: make

    $(WGS) -u <url> -o $(BUILD_DIR)/<output file>

Example:

.. sourcecode:: make

    # Name of the package
    NAME = libemf2svg
    
    # Version
    VERSION = 1.0.1
    
    # URL of the project 
    URL=https://github.com/kakwa/libemf2svg
    
    # Source recovery url
    URL_SRC=$(URL)/archive/$(VERSION).tar.gz
    
    # Including common rules and targets 
    include buildenv/Makefile.common
    
    $(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
            $(WGS) -u $(URL_SRC) -o $(SOURCE_ARCHIVE)


Building the MANIFEST file
~~~~~~~~~~~~~~~~~~~~~~~~~~

To create the MANIFEST file, just run the following command:

.. sourcecode:: bash

    make manifest

Source preparation
~~~~~~~~~~~~~~~~~~

The source preparation is made in the **$(SOURCE_ARCHIVE)** target.

The goal of this rule is to create the **tar.gz** archive **$(SOURCE_ARCHIVE)**.

The root directory of the source archive should be **$(NAME)-$(VERSION)**.
For example:

.. sourcecode:: bash

    tar -tvf cache/mk-sh-skel_1.0.0.orig.tar.gz 
    drwxrwxr-x root/root         0 2015-11-27 00:26 mk-sh-skel-1.0.0/
    -rw-rw-r-- root/root      1135 2015-11-27 00:26 mk-sh-skel-1.0.0/LICENSE
    -rw-rw-r-- root/root       145 2015-11-27 00:26 mk-sh-skel-1.0.0/Makefile
    -rw-rw-r-- root/root       972 2015-11-27 00:26 mk-sh-skel-1.0.0/README.md
    -rw-rw-r-- root/root      1037 2015-11-27 00:26 mk-sh-skel-1.0.0/mksh-skel


In ideal cases, it's only a matter of downloading the upstream sources as these conventions are quite standards.
For example:

.. sourcecode:: make

    # Version
    VERSION = 1.0.1
    
    # URL of the project 
    URL=https://github.com/kakwa/mk-sh-skel
    
    # example of source recovery url
    URL_SRC=$(URL)/archive/$(VERSION).tar.gz
    
    # Basic source archive recovery,
    # this works fine if upstream is clean
    $(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
            $(WGS) -u $(URL_SRC) -o $(SOURCE_ARCHIVE)

But in some cases, it might be necessary to modify the upstream sources content.

For that two helper variables are provided:

* **$(SOURCE_DIR)**: source directory (with proper naming convention) where to put sources before building the source archive.
* **$(SOURCE_TAR_CMD)**: once **$(SOURCE_DIR)** is filled with content, just call this variable,
  it will generate the **$(SOURCE_ARCHIVE)** tar.gz and do some cleanup.
  If present, **$(SOURCE_TAR_CMD)** should be the last step in **$(SOURCE_ARCHIVE)** target.

For example:

.. sourcecode:: make

    # Version
    VERSION = 1.0.7
    
    # URL of the project 
    URL=http://repos.entrouvert.org/python-rfc3161.git
    
    # example of source recovery url
    URL_SRC=$(URL)/snapshot/python-rfc3161-$(VERSION).tar.gz
    
    # preparation of the sources with removal of upstream, unwanted debian/ packaging
    # it does the following:
    # * recover upstream archive
    # * uncompress it
    # * upstream modification (remove the unwanted debian/ dir from upstream source)
    # * move remaining stuff to $(SOURCE_DIR)
    # * do some cleanup
    # * build the archive

    $(SOURCE_ARCHIVE): $(SOURCE_DIR) $(CACHE) Makefile MANIFEST
            $(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/python-rfc3161-$(VERSION).tar.gz
            mkdir -p $(BUILD_DIR)/tmp
            tar -vxf $(BUILD_DIR)/$(NAME)-$(VERSION).tar.gz -C $(BUILD_DIR)/tmp
            rm -rf $(BUILD_DIR)/tmp/python-rfc3161-$(VERSION)/debian
            mv $(BUILD_DIR)/tmp/python-rfc3161-$(VERSION)/* $(SOURCE_DIR)
            rm -rf $(BUILD_DIR)/tmp
            rm -f $(BUILD_DIR)/python-rfc3161-$(VERSION).tar.gz
            $(SOURCE_TAR_CMD)

Distribution specific packaging
===============================

For the most part, just package according to deb/rpm documentation,
filling the **rpm/component.spec**, **debian/rules**, **debian/control**, or any other packaging files if necessary.

.. note::

     I would advise you to try to respect the distributions guidelines and standards such
     as the FHS (https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard).

deb
~~~

For Debian packages, just leverage the usual packaging patterns such as
the **PKG.init**, **PKG.default**, **PKG.service**, ... files and the **override_dh_*** targets in **debian/rules**, and then,
add your dependencies and architecture(s) in the **debian/control** file.

.. note::

    In many cases, with clean upstreams, there is nearly nothing to do except dependencies and architecture,
    the various dh_helpers will do their magic and build a clean package.

    If you are unlucky, uncomment the **export DH_VERBOSE=1** in **debian/rules** and customize
    the build as necessary using the **override_dh_*** targets.

rpm
~~~

For rpm, fill the various sections of the **rpm/component.spec** file such
as **BuildRequires:**, **Requires:** or **BuildArch:** parameters and the various sections like **%install**.

If additional files a required for packaging, an init script for example, put these files
in the **rpm/** directory.

All additional files in the **rpm/** directory are copied in the rpmbuild **SOURCES** directory.
This means that it's possible to treat them as additional source files in **component.spec**
with the **Source[0-9]:** directives.

Example for ldapcherry.service systemd service file and it's associated files:

.. sourcecode:: bash

   # rpm/ directory content
   tree rpm/
   rpm/
   ├── component.spec
   ├── ldapcherry
   ├── ldapcherry.conf
   └── ldapcherry.service

.. sourcecode:: bash

   # component.spec relevant sections
   Source: %{pkgname}-%{version}.tar.gz
   Source1: ldapcherry
   Source2: ldapcherry.conf
   Source3: ldapcherry.service

   # install section
   %install

   # install the .service, the sysconfig file and tmpfiles.d (for pid file creation as non-root user)
   mkdir -p %{buildroot}%{_unitdir}
   mkdir -p %{buildroot}/usr/lib/tmpfiles.d/
   mkdir -p %{buildroot}/etc/sysconfig/
   install -pm644 %{SOURCE1} %{buildroot}/etc/sysconfig/
   install -pm644 %{SOURCE2} %{buildroot}/usr/lib/tmpfiles.d/
   install -pm644 %{SOURCE3} %{buildroot}%{_unitdir}

Distribution version specific packaging files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. warning:: not implemented yet
