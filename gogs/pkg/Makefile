# Name of the package
NAME = gogs

# Version
VERSION = 0.8.10

VERSION_gopkg.in/bufio.v1=v1
VERSION_gopkg.in/gomail.v2=2.0.0
VERSION_gopkg.in/ini.v1=2e44421
VERSION_gopkg.in/macaron.v1=1c6dd87
VERSION_gopkg.in/redis.v2=v2.3.2
VERSION_gopkg.in/ldap.v2=v2.2
VERSION_gopkg.in/asn1-ber.v1=v1.1
VERSION_github.com/alexcesaro/quotedprintable=2caba252f4dc53eaf6b553000885530023f54623
VERSION_github.com/bradfitz/gomemcache=72a68649ba
VERSION_github.com/go-macaron/inject=c5ab7bf
VERSION_github.com/kardianos/minwinsvc=cad6b2b879b0970e4245a20ebf1a81a756e2bb70
VERSION_github.com/klauspost/compress=bbfa9dc
VERSION_github.com/klauspost/cpuid=8d9fe96
VERSION_github.com/klauspost/crc32=3e5c38b
VERSION_github.com/mattn/go-sqlite3=5651a9d
VERSION_github.com/msteinert/pam=6534f23b39
VERSION_github.com/shurcooL/sanitized_anchor_name=10ef21a
VERSION_github.com/Unknwon/cae=7f5e046
VERSION_github.com/Unknwon/com=28b053d
VERSION_github.com/Unknwon/i18n=3b48b6662051bed72d36efa3c1e897bdf96b2e37
VERSION_github.com/Unknwon/paginater=7748a72
VERSION_github.com/codegangsta/cli=0302d39
VERSION_github.com/go-macaron/binding=864a5ce
VERSION_github.com/go-macaron/cache=5617353
VERSION_github.com/go-macaron/captcha=875ff77
VERSION_github.com/go-macaron/csrf=3372b25
VERSION_github.com/go-macaron/gzip=4938e9b
VERSION_github.com/go-macaron/i18n=d2d3329f13b52314f3292c4cecb601fad13f02c8
VERSION_github.com/go-macaron/session=66031fc
VERSION_github.com/go-macaron/toolbox=ab30a81
VERSION_github.com/go-sql-driver/mysql=d512f20
VERSION_github.com/go-xorm/core=3e10003353
VERSION_github.com/go-xorm/xorm=c643188
VERSION_github.com/gogits/chardet=2404f77725
VERSION_github.com/gogits/go-gogs-client=2a795f081a1b780357d4809f3b1f0941f473e9b9
VERSION_github.com/gogits/git-shell=1ffc4bc
VERSION_github.com/gogits/git-module=261798320be2129843878d87ca441706cf8b3edf
VERSION_github.com/issue9/identicon=5a61672
VERSION_github.com/lib/pq=83c4f41
VERSION_github.com/mcuadros/go-version=d52711f
VERSION_github.com/microcosm-cc/bluemonday=4ac6f27
VERSION_github.com/nfnt/resize=dc93e1b98c
VERSION_github.com/russross/blackfriday=300106c
VERSION_golang.org/x/crypto=beef0f4390813b96e8e68fd78570396d0f4751fc
VERSION_golang.org/x/net=b092070472000b3147a7bdaf7cfc9515cf90514f
VERSION_golang.org/x/text=e6847002810c51f892a128333573eac5e2a62024

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
