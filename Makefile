TARGET := iphone:clang:latest:14.0
ARCHS := arm64 arm64e
INSTALL_TARGET_PROCESSES :=
include $(THEOS)/makefiles/common.mk
LIBRARY_NAME = KDAdBlock
KDAdBlock_FILES = KDAdBlock.m
KDAdBlock_CFLAGS = -fobjc-arc
KDAdBlock_FRAMEWORKS = Foundation
include $(THEOS_MAKE_PATH)/library.mk
