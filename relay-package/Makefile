RELAYSERVER_PROJECT_DIR := $(abspath $(CURDIR)/..)
RELAYSERVER_TARGET := aarch64-apple-ios
RELAYSERVER_PROFILE ?= release
RELAYSERVER_BIN := $(RELAYSERVER_PROJECT_DIR)/target/$(RELAYSERVER_TARGET)/$(RELAYSERVER_PROFILE)/relayserver
RELAYSERVER_DEPLOYMENT_TARGET ?= 15.0
RELAYSERVER_PROFILE_FLAG := $(if $(filter release,$(RELAYSERVER_PROFILE)),--release,)
LDID ?= $(shell command -v ldid 2>/dev/null || echo $(THEOS)/bin/ldid)
export TARGET := iphone:clang:latest:15.0
export ARCHS := arm64
export THEOS_PACKAGE_SCHEME ?= rootless

include $(THEOS)/makefiles/common.mk

after-stage::
	cd $(RELAYSERVER_PROJECT_DIR) && \
		SDKROOT="$$(xcrun --sdk iphoneos --show-sdk-path)" \
		IPHONEOS_DEPLOYMENT_TARGET="$(RELAYSERVER_DEPLOYMENT_TARGET)" \
		cargo build --target $(RELAYSERVER_TARGET) $(RELAYSERVER_PROFILE_FLAG)
	mkdir -p $(THEOS_STAGING_DIR)/usr/local/bin
	install -m 0755 $(RELAYSERVER_BIN) $(THEOS_STAGING_DIR)/usr/local/bin/relayserver
	$(LDID) -S$(RELAYSERVER_PROJECT_DIR)/Entitlements.xml $(THEOS_STAGING_DIR)/usr/local/bin/relayserver

include $(THEOS_MAKE_PATH)/null.mk
