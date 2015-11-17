# packages

Stuff I package for fun and profit

## Init packaging directories

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
    * the packaging stuff (*debian* directory, spec file)
    * a Makefile (used to download and prepare upstream sources)
    * a MANIFEST (listing the downloaded files and their hash)
* **src**: this directory contains all the files added to the sources (ex: launcher script)

## Recover resources

To recover resources from a third party website, proceed as followed in the Makefile:

```make
# declare the upstream version
VERSION = 0.2.2

# declare the upstream url
# avoid hardcoding version in upstream names if possible
URL=https://github.com/kakwa/ldapcherry/archive/$(VERSION).tar.gz

# recover the file
# use $(WGS) -u <url> -o <output file> as this utility handles checksum and caching
src_prepare_rpm:
    $(WGS) -u $(URL) -o $(BUILD_DIR)/archive.tar.gz
    ... # do stuff with the archive like putting its content in $(BUILD_DIR)/src
```

To create the MANIFEST file, just run the following:

```bash
$ make manifest
```

## Build the packages

```bash
# build deb package
$ make deb

# build rpm package
$ make rpm
```
