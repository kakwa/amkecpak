# Packages

Stuff I package for fun and profit.

# Necessary tools:

```bash
# CentOS/RHEL/Fedora
$ yum install rpm-sign expect rpm-build createrepo rsync make

# Debian/Ubuntu
$ apt-get install make debhelper reprepro lsb-release
```

# Creating a package

Creating a package <foo> involves the following steps:

* Initialize the packaging directories.
* Fill <foo>/pkg/Makefile (used for common metadata and upstream source recovery and preparation).
* Do the distribution specific stuff (dependencies in debian/control and <foo>.spec, pre/post install scripts, init scripts, etc)

## Initialize packaging directories

To create packaging skeleton:

```bash
$ ./common/init_pkg.sh -n foo
```

This will create the following tree:

```
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
```

This tree contains two main directories:

* **pkg**: this directory contains:
    * the packaging stuff (*debian/* directory, spec file)
    * Makefile (used to download and prepare upstream sources)
    * MANIFEST (listing the downloaded files and their hash)
* **src**: this directory contains all the files added to the sources (ex: launcher script)

## Fill common metadata

The following metadata must be filled inside the Makefile:

```
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
SUMMARY="Not a package summary"

# long version of the summary, (but I could be lazy)
DESCRIPTION=$(SUMMARY)
```

During build, the @<VAR>@ (like @URL@ or @SUMMARY@) will be automatically substituted in various packaging files.

## Recovering and preparing upstream resources

To recover resources from a third party website, please use the **$(WGS)** command:

```
    $(WGS) -u <url> -o <output file>
```

This command not only recovers the resources, but also caches it, and performs a checksum against it.
Each upstream resources checksums are stored in the **MANIFEST** file.

example:

```make
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
    $(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/src.tar.gz
    tar -vxf $(BUILD_DIR)/src.tar.gz -C $(BUILD_DIR)/
    mv $(BUILD_DIR)/py-ascii-graph-$(VERSION)/* $(BUILD_DIR)/src/
    rm -rf py-ascii-graph-$(VERSION)
    rm -f $(BUILD_DIR)/src.tar.gz
```

To create the MANIFEST file, just run the following command:

```bash
$ make manifest
```

## Distribution specific packaging

Nothing special here, just package according to deb/rpm documentation.

# Building the packages

## Individual package 

To build a package, just invoke **make deb** or **make rpm** depending on the target.

Example:

```bash
# go inside the component directory
$ cd python-asciigraph/pkg/

# optionnally, clean cache/ and out/ directory
$ make clean

# build deb package
$ make deb

# build rpm package
$ make rpm

# output packages:
$ ls out/
python-asciigraph_1.1.3-1_all.deb  python-asciigraph-1.1.3-1.unk.noarch.rpm

# output source package
$ ls src-out/
python-asciigraph_1.1.3-1.debian.tar.xz  python-asciigraph-1.1.3-1.unk.src.rpm
python-asciigraph_1.1.3-1.dsc            python-asciigraph_1.1.3.orig.tar.gz
```

## Complete repositories

### Repository metadata

First, you need to fill the repositories metadata:

```make
# Name of the gpg key to use
GPG_KEY="kakwa"
# Output directory for the repos
OUTPUT="out/"
# Package provider
ORIGIN="kakwa"
```


### Create the repositories

```bash
# optionnally, cleaning everything
$ make clean

# create the deb repository
$ make deb_repo -j 4

# create the rpm repository
$ make rpm_repo -j 4

# create everything
$ make all -j 4
```

### GPG cheat sheet

Generate the GPG key:

```bash
$ gpg --gen-key
```

List the keys:
```bash
$ gpg -K
```

Export the private key (multiple hosts):
```
$ gpg --export-secret-key -a "kakwa" > priv.gpg
```

Import the private key:
```bash
gpg --import priv.gpg
```

import the key in debian:
```
cat pub.gpg | apt-key add -
```
