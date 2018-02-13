include theos/makefiles/common.mk
export ARCHS = armv7 armv7s arm64
export SDKVERSION = 7.1
BUNDLE_NAME = anchor
anchor_FILES = UIImage+animatedGIF.mm AnchorListController.mm AnchorSwitch.mm AnchorResetAll.mm
anchor_INSTALL_PATH = /Library/PreferenceBundles
anchor_FRAMEWORKS = UIKit ImageIO QuartzCore CoreGraphics
anchor_PRIVATE_FRAMEWORKS = Preferences AppSupport
anchor_LIBRARIES = applist
ADDITIONAL_OBJCFLAGS = -Wno-deprecated-declarations
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/anchor.plist$(ECHO_END)
