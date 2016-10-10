# Make sure we're failing even though we pipe to xcpretty
SHELL=/bin/bash -o pipefail

BUILD_PLATFORM=iOS Simulator,name=iPhone 6,OS=10.0
WORKING_DIR = Example/TSKitiOSTestApp
SCHEME = TSKitiOSTestApp
XCODE_BUILD = xcrun xcodebuild -workspace $(SCHEME).xcworkspace -scheme $(SCHEME) -sdk iphonesimulator

.PHONY: build test retest clean

default: test

test: pod_install retest

pod_install:
	cd $(WORKING_DIR) && \
		pod install

build: pod_install
	cd $(WORKING_DIR) && \
		$(XCODE_BUILD) build | xcpretty

retest:
	cd $(WORKING_DIR) && \
		$(XCODE_BUILD) \
			-destination 'platform=${BUILD_PLATFORM}' \
			test | xcpretty

clean:
	cd $(WORKING_DIR) && \
		$(XCODE_BUILD) \
			clean | xcpretty

