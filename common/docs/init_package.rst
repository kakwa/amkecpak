Create a package
----------------

Creating a package *foo* involves the following steps:

* Initialize the packaging directories.
* Fill **foo**/pkg/Makefile (used for common metadata and upstream source recovery and preparation).
* Do the distribution specific stuff (dependencies in *debian/control* and *foo.spec*, pre/post install scripts, init scripts, etc)

Initialize packaging directories
================================

To create the package skeleton:

.. sourcecode:: bash

    $ ./common/init_pkg.sh -n foo

This script will create the following tree:

.. sourcecode:: none

    foo
    ├── pkg
    │   ├── buildenv -> ../../common/buildenv
    │   ├── debian
    │   │   ├── changelog
    │   │   ├── compat
    │   │   ├── conffiles
    │   │   ├── control
    │   │   ├── copyright
    │   │   ├── foo.cron.d.ex
    │   │   ├── foo.default.ex
    │   │   ├── init.d.ex
    │   │   ├── postinst.ex
    │   │   ├── postrm.ex
    │   │   ├── preinst.ex
    │   │   ├── prerm.ex
    │   │   ├── rules
    │   │   └── source
    │   │       └── format
    │   ├── foo.spec
    │   ├── Makefile
    │   └── MANIFEST
    └── src

This tree contains two main directories:

* **pkg**: this directory contains:
    * the packaging stuff (*debian/* directory, *.spec* file)
    * *Makefile* (used to download and prepare upstream sources)
    * *MANIFEST* (listing the downloaded files and their hash)
* **src**: this directory contains all the files added to the sources (ex: launcher script)

Package metadata
================

The package metadata (version, name, description, etc) are declared at the top of the package Makefile:

.. sourcecode:: make

    # Version
    # if possible, keep the upstream version
    VERSION=0.0.1
    
    # Revision number
    # increment it when fixing packaging for a given release
    # reset it to one if version bump
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

    Don't remove the @VAR@ (ex: @SUMMARY@ or @URL@) in the packaging files.

Download upstream sources
=========================

This packaging infrastructure comes with a small tool (*./common/buildenv/wget_sum.sh*) to handle downloads.

This tool role is:

* Download upstream sources.
* Check the integrity of the upstream source against the *MANIFEST* file (sha512 sum).
* Build the *MANIFEST* file if requested
* Handling a local download cache to avoid downloading sources at each build

Download tool usage
~~~~~~~~~~~~~~~~~~~

Inside the Makefile, use it as followed:

.. sourcecode:: make

    $(WGS) -u <url> -o $(BUILD_DIR)/<output file>

Example:

.. sourcecode:: make

    # declare the upstream version
    VERSION = 1.1.3
    
    # URL of the project
    URL=https://github.com/kakwa/py-ascii-graph
    
    # declare the upstream url
    # avoid hardcoding version in upstream names if possible
    URL_SRC=$(URL)/archive/$(VERSION).tar.gz
    
    # recover the file
    # use $(WGS) -u <url> -o <output file> as this utility handles checksum and caching
    src_prepare_rpm:
        $(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/py-ascii-graph-$(VERSION).tar.gz
        tar -vxf $(BUILD_DIR)/py-ascii-graph-$(VERSION).tar.gz -C $(BUILD_DIR)/
        mv $(BUILD_DIR)/py-ascii-graph-$(VERSION)/* $(BUILD_DIR)/src/
        rm -rf $(BUILD_DIR)/py-ascii-graph-$(VERSION)*

    src_prepare_deb: src_prepare_rpm

Building the MANIFEST file
~~~~~~~~~~~~~~~~~~~~~~~~~~

To create the MANIFEST file, just run the following command:

.. sourcecode:: bash

    $ make manifest

Source preparation
~~~~~~~~~~~~~~~~~~

The source preparation is made in the **src_prepare_rpm** and **src_prepare_deb** (depending on the target).

By default, both targets will do the same thing  as **src_prepare_rpm** is a dependancy of **src_prepare_deb**.
However, this behaviour could be changed if necessary.


The goal of these rules is basically to fill the **$(BUILD_DIR)/src/** directory with the upstream sources and 
insert the package specific sutff.

.. warning::

    The preparation steps must not modify, delete or add files outside **$(BUILD_DIR)**, everything must be done inside
    this directory.

Distribution specific packaging
===============================

Nothing special here, just package according to deb/rpm documentation.
