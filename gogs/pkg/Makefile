# Name of the package
NAME = gogs

# Version
VERSION = 0.7.22

# Gogs dependancies versions
VERSION_gomail.v2=2.0.0
VERSION_ini.v1=2e44421
VERSION_macaron.v1=1c6dd87
VERSION_redis.v2=v2.3.2
VERSION_bradfitz_gomemcache=72a68649ba
VERSION_go-macaron_inject=c5ab7bf
VERSION_klauspost_compress=bbfa9dc
VERSION_klauspost_cpuid=8d9fe96
VERSION_klauspost_crc32=3e5c38b
VERSION_mattn_go-sqlite3=5651a9d
VERSION_msteinert_pam=6534f23b39
VERSION_shurcooL_sanitized_anchor_name=10ef21a
VERSION_Unknwon_cae=7f5e046
VERSION_Unknwon_com=28b053d
VERSION_Unknwon_i18n=7457d88830
VERSION_Unknwon_paginater=7748a72
VERSION_codegangsta_cli=0302d39
VERSION_go-macaron_binding=864a5ce
VERSION_go-macaron_cache=5617353
VERSION_go-macaron_captcha=875ff77
VERSION_go-macaron_csrf=3372b25
VERSION_go-macaron_gzip=4938e9b
VERSION_go-macaron_i18n=5e728b6
VERSION_go-macaron_session=66031fc
VERSION_go-macaron_toolbox=ab30a81
VERSION_go-sql-driver_mysql=d512f20
VERSION_go-xorm_core=3e10003353
VERSION_go-xorm_xorm=c643188
VERSION_gogits_chardet=2404f77725
VERSION_gogits_go-gogs-client=7c02c95
VERSION_issue9_identicon=5a61672
VERSION_lib_pq=83c4f41
VERSION_mcuadros_go-version=d52711f
VERSION_microcosm-cc_bluemonday=4ac6f27
VERSION_nfnt_resize=dc93e1b98c
VERSION_russross_blackfriday=300106c
VERSION_x_crypto=beef0f4390813b96e8e68fd78570396d0f4751fc
VERSION_x_net=b092070472000b3147a7bdaf7cfc9515cf90514f
VERSION_x_text=e6847002810c51f892a128333573eac5e2a62024

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
