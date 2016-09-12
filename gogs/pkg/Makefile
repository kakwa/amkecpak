# Name of the package
NAME = gogs

# Version
VERSION = 0.9.97

VERSION_github.com/bradfitz/gomemcache=fb1f79c
VERSION_github.com/urfave/cli=1efa31f
VERSION_github.com/go-macaron/binding=9440f33
VERSION_github.com/go-macaron/cache=5617353
VERSION_github.com/go-macaron/captcha=8aa5919
VERSION_github.com/go-macaron/csrf=6a9a7df
VERSION_github.com/go-macaron/gzip=cad1c65
VERSION_github.com/go-macaron/i18n=ef57533
VERSION_github.com/go-macaron/inject=c5ab7bf
VERSION_github.com/go-macaron/session=66031fc
VERSION_github.com/go-macaron/toolbox=82b5115
VERSION_github.com/go-sql-driver/mysql=0b58b37
VERSION_github.com/go-xorm/core=5bf745d
VERSION_github.com/go-xorm/xorm=c6c7056
VERSION_github.com/gogits/chardet=2404f77
VERSION_github.com/gogits/cron=7f3990a
VERSION_github.com/gogits/git-module=5e0c133
VERSION_github.com/gogits/go-gogs-client=c52f7ee
VERSION_github.com/issue9/identicon=d36b545
VERSION_github.com/jaytaylor/html2text=52d9b78
VERSION_github.com/kardianos/minwinsvc=cad6b2b
VERSION_github.com/klauspost/compress=14eb9c4
VERSION_github.com/klauspost/cpuid=09cded8
VERSION_github.com/klauspost/crc32=19b0b33
VERSION_github.com/lib/pq=80f8150
VERSION_github.com/mattn/go-sqlite3=e118d44
VERSION_github.com/mcuadros/go-version=d52711f
VERSION_github.com/microcosm-cc/bluemonday=9dc1992
VERSION_github.com/msteinert/pam=02ccfbf
VERSION_github.com/nfnt/resize=891127d
VERSION_github.com/russross/blackfriday=93622da
VERSION_github.com/satori/go.uuid=0aa62d5
VERSION_github.com/sergi/go-diff=ec7fdbb
VERSION_github.com/strk/go-libravatar=5eed7bf
VERSION_github.com/shurcooL/sanitized_anchor_name=10ef21a
VERSION_github.com/Unknwon/cae=7f5e046
VERSION_github.com/Unknwon/com=28b053d
VERSION_github.com/Unknwon/i18n=39d6f27
VERSION_github.com/Unknwon/paginater=7748a72
VERSION_golang.org/x/crypto=bc89c49
VERSION_golang.org/x/net=57bfaa8
VERSION_golang.org/x/sys=a646d33
VERSION_golang.org/x/text=2910a50
VERSION_gopkg.in/alexcesaro/quotedprintable.v3=2caba25
VERSION_gopkg.in/asn1-ber.v1=4e86f43
VERSION_gopkg.in/bufio.v1=567b2bf
VERSION_gopkg.in/editorconfig/editorconfig-core-go.v1=a872f05
VERSION_gopkg.in/gomail.v2=81ebce5
VERSION_gopkg.in/ini.v1=cf53f92
VERSION_gopkg.in/ldap.v2=d0a5ced
VERSION_gopkg.in/macaron.v1=7564489
VERSION_gopkg.in/redis.v2=e617904


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
