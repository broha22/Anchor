
export ARCHS = armv7 arm64
export SDKVERSION=7.1
#export TARGET=iphone::7.1

include theos/makefiles/common.mk

TWEAK_NAME = Anchor
Anchor_FILES = anchor.xm AnchorLayoutRotationController.xm
Anchor_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore
#ADDITIONAL_OBJCFLAGS = -Wno-deprecated-declarations
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += anchor
include $(THEOS_MAKE_PATH)/aggregate.mk
