# Name of the package
NAME = gogs

# Version
VERSION = 0.8.43

VERSION_github.com/bradfitz/gomemcache=fb1f79c
VERSION_github.com/codegangsta/cli=5db7419
VERSION_github.com/go-macaron/binding=a68f342
VERSION_github.com/go-macaron/cache=5617353
VERSION_github.com/go-macaron/captcha=8aa5919
VERSION_github.com/go-macaron/csrf=715bca0
VERSION_github.com/go-macaron/gzip=cad1c65
VERSION_github.com/go-macaron/i18n=d2d3329
VERSION_github.com/go-macaron/inject=c5ab7bf
VERSION_github.com/go-macaron/session=66031fc
VERSION_github.com/go-macaron/toolbox=82b5115
VERSION_github.com/go-sql-driver/mysql=1309049
VERSION_github.com/go-xorm/core=9ddf4ee
VERSION_github.com/go-xorm/xorm=e72082c
VERSION_github.com/gogits/chardet=2404f77725
VERSION_github.com/gogits/git-module=a1c5096
VERSION_github.com/gogits/go-gogs-client=d584b1e
VERSION_github.com/issue9/identicon=f8c0d2c
VERSION_github.com/kardianos/minwinsvc=cad6b2b
VERSION_github.com/klauspost/compress=f962535
VERSION_github.com/klauspost/cpuid=2c698c6
VERSION_github.com/klauspost/crc32=19b0b33
VERSION_github.com/lib/pq=69552e5
VERSION_github.com/mattn/go-sqlite3=09d5c45
VERSION_github.com/mcuadros/go-version=d52711f
VERSION_github.com/microcosm-cc/bluemonday=4ac6f27
VERSION_github.com/msteinert/pam=02ccfbf
VERSION_github.com/nfnt/resize=4d93a29
VERSION_github.com/russross/blackfriday=006144a
VERSION_github.com/gogits/cron=3abc0f88
VERSION_github.com/satori/go.uuid=e673fdd
VERSION_github.com/sergi/go-diff=ec7fdbb
VERSION_github.com/shurcooL/sanitized_anchor_name=10ef21a
VERSION_github.com/Unknwon/cae=7f5e046
VERSION_github.com/Unknwon/com=28b053d
VERSION_github.com/Unknwon/i18n=3b48b66
VERSION_github.com/Unknwon/paginater=7748a72
VERSION_golang.org/x/net=4599ae7
VERSION_golang.org/x/text=07b9a78
VERSION_golang.org/x/crypto=1f22c01
VERSION_gopkg.in/asn1-ber.v1=4e86f43
VERSION_gopkg.in/gomail.v2=fbb71dd
VERSION_gopkg.in/ini.v1=776aa73
VERSION_gopkg.in/ldap.v2=07a7330
VERSION_gopkg.in/macaron.v1=b9eee38
VERSION_gopkg.in/redis.v2=e617904962
VERSION_gopkg.in/bufio.v1=v1

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/gogits/gogs

# short summary of what the package provides
SUMMARY=Gogs (Go Git Service) is a painless self-hosted Git service.

# long version of the summary, but I'm lazy
DESCRIPTION=$(SUMMARY)

###############################################################################
# Rule #
########

GH=https://github.com/

# example of source recovery url
URL_SRC=$(URL)/archive/v$(VERSION).tar.gz

GO_EXT=./buildenv/go_extract.sh -d $(BUILD_DIR)/src/externals/

# Including common rules and targets 
include buildenv/Makefile.common

# preparation hook for rpm package
# source archives must recovered here
# and their content put inside $(BUILD_DIR)/src
#
# $(WGS) should be the prefered way to recover archives
# (add checksum against a manifest file).
# use 'make manifest' to generate/update this manifest file.

include Makefile.meta
include Makefile.get

src_prepare_rpm: prepare_deps
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/gogs-$(VERSION).tar.gz
	mkdir -p $(BUILD_DIR)/src/externals/src/github.com/gogits/
	ln -s ../../../../ $(BUILD_DIR)/src/externals/src/github.com/gogits/gogs
	tar -xf $(BUILD_DIR)/gogs-$(VERSION).tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/gogs-$(VERSION)/* $(BUILD_DIR)/src/
	rm -rf $(BUILD_DIR)/gogs-$(VERSION)/
	rm -f $(BUILD_DIR)/gogs-$(VERSION).tar.gz

# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
