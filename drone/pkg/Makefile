# Name of the package
NAME = drone

# Version
VERSION = 0.4.0

# Drone dependancies versions
VERSION_code.google.com/p/go.crypto=beef0f4390813b96e8e68fd78570396d0f4751fc
VERSION_github.com/Bugagazavr/go-gitlab-client=e5999f934dc45c41073fc57998a1224a75ff7d50
VERSION_github.com/Sirupsen/logrus=v0.8.7
VERSION_github.com/dgrijalva/jwt-go=v2.4.0
VERSION_github.com/docker/docker=v1.9.1
VERSION_github.com/eknkc/amber=144da19a9994994c069f0693294a66dd310e14a4
VERSION_github.com/elazarl/go-bindata-assetfs=d5cac425555ca5cf00694df246e04f05e6a55150
VERSION_github.com/gin-gonic/gin=v1.0rc1
VERSION_github.com/go-sql-driver/mysql=v1.2
VERSION_github.com/gogits/go-gogs-client=7c02c9529986c5f4a61db75b3a57500ba08c9278
VERSION_github.com/google/go-github=47f2593dad1971eec2f0a0971aa007fef5edbc50
VERSION_github.com/gorilla/securecookie=e95799a481bbcc3d01c2ad5178524cb8bec9f370
VERSION_github.com/koding/cache=487fc0ca06f9aa1a02d796f5510784b47d5afae2
VERSION_github.com/lib/pq=11fc39a580a008f1f39bb3d11d984fb34ed778d9
VERSION_github.com/manucorporat/sse=fe6ea2c8e398672518ef204bf0fbd9af858d0e15
VERSION_github.com/mattn/go-sqlite3=v1.1.0
VERSION_github.com/rubenv/sql-migrate=53184e1edfb4f9655b0fa8dd2c23e7763f452bda
VERSION_github.com/russross/meddler=f742b0f9424f3bfaffe189e921d734608929e84f
VERSION_github.com/samalba/dockerclient=82381805d3533c97cec74e1cc79b00ef45774571
VERSION_github.com/square/go-jose=37934a899dd03635373fd1e143936d32cfe48d31
VERSION_golang.org/x/net=195180cfebf7362bd243a52477697895128c8777
VERSION_golang.org/x/oauth2=442624c9ec9243441e83b374a9e22ac549b5c51d
VERSION_gopkg.in/yaml.v2=f7716cbe52baa25d2e9b0d0da546fcf909fc16b4

# Revision number 
RELEASE = 1

# URL of the project 
URL=https://github.com/drone/drone

# short summary of what the package provides
SUMMARY=Continuous Integration platform built on Docker, written in Go

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
	$(WGS) -u $(URL_SRC) -o $(BUILD_DIR)/drone-$(VERSION).tar.gz
	mkdir -p $(BUILD_DIR)/src/externals/src/github.com/drone/
	ln -s ../../../../ $(BUILD_DIR)/src/externals/src/github.com/drone/drone
	tar -xf $(BUILD_DIR)/drone-$(VERSION).tar.gz -C $(BUILD_DIR)/
	mv $(BUILD_DIR)/drone-$(VERSION)/* $(BUILD_DIR)/src/
	rm -rf $(BUILD_DIR)/drone-$(VERSION)/
	rm -f $(BUILD_DIR)/drone-$(VERSION).tar.gz

# preparation hook for deb package.
# by default, same as rpm package but could be override
src_prepare_deb: src_prepare_rpm
