PRODUCT_BRAND ?= xoplax-os

PREVIEW_VERSION := 1011
XOPLAX_BASE := KK

SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.cyanogenmod.superuser

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/xoplax/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/xoplax/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/xoplax/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

ifdef XOPLAX_NIGHTLY
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=xoplax-nightly
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=xoplax-release
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable multithreaded dexopt by default
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.dalvik.multithread=false

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/xoplax/CHANGELOG.mkdn:system/etc/CHANGELOG-CM.txt

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/xoplax/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/xoplax/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/xoplax/prebuilt/common/bin/50-cm.sh:system/addon.d/50-cm.sh \
    vendor/xoplax/prebuilt/common/bin/blacklist:system/addon.d/blacklist 
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/xoplax/prebuilt/common/bin/otasigcheck.sh:system/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/xoplax/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/xoplax/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/xoplax/prebuilt/common/etc/init.d/99mediaserverkiller:system/etc/init.d/99mediaserverkiller \
    vendor/xoplax/prebuilt/common/etc/init.d/05netspeed:system/etc/init.d/05netspeed \
    vendor/xoplax/prebuilt/common/etc/init.d/99zram:system/etc/init.d/99zram \
    vendor/xoplax/prebuilt/common/etc/init.d/99Batterysaver:system/etc/init.d/99Batterysaver \
    vendor/xoplax/prebuilt/common/etc/init.d/sysctl_tweaks:system/etc/init.d/sysctl_tweaks \
    vendor/xoplax/prebuilt/common/etc/init.d/09setrenice:system/etc/init.d/09setrenice \
    vendor/xoplax/prebuilt/common/etc/init.d/00batterycalibrate:system/etc/init.d/00batterycalibrate \
    vendor/xoplax/prebuilt/common/etc/init.d/04journalism:system/etc/init.d/04journalism \
    vendor/xoplax/prebuilt/common/etc/init.d/14enable_touchscreen:system/etc/init.d/14enable_touchscreen \
    vendor/xoplax/prebuilt/common/etc/init.d/47Kernel:system/etc/init.d/47Kernel \
    vendor/xoplax/prebuilt/common/etc/init.d/S97ramscript:system/etc/init.d/S97ramscript

# userinit support
PRODUCT_COPY_FILES += \
    vendor/xoplax/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# CM-specific init file
PRODUCT_COPY_FILES += \
    vendor/xoplax/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/xoplax/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/xoplax/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Include CM permission
PRODUCT_COPY_FILES += \
    vendor/xoplax/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Bring in Xoplax LS
PRODUCT_COPY_FILES += \
    vendor/xoplax/prebuilt/common/addon.d/01_lockscreen.sh:system/addon.d/01_lockscreen.sh \
    vendor/xoplax/prebuilt/common/priv-app/CMKeyguard.apk:system/priv-app/CMKeyguard.apk 

# We replace DSP Manager to MAXX Audio
PRODUCT_COPY_FILES += \
    vendor/xoplax/prebuilt/common/app/MaxxAudio.apk:system/app/MaxxAudio.apk \
    vendor/xoplax/prebuilt/common/lib/libEQGraphLib.so:system/lib/libEQGraphLib.so \
    vendor/xoplax/prebuilt/common/lib/libMA3-processcode-Coretex_A9.so:system/lib/libMA3-processcode-Coretex_A9.so \
    vendor/xoplax/prebuilt/common/lib/libMA3-wavesfx-Coretex_A9.so:system/lib/libMA3-wavesfx-Coretex_A9.so \
    vendor/xoplax/prebuilt/common/lib/libosl-maxxaudio-itf.so:system/lib/libosl-maxxaudio-itf.so \
    vendor/xoplax/prebuilt/common/lib/libwavesfxservice.so:system/lib/libwavesfxservice.so \
    vendor/xoplax/prebuilt/common/lib/soundfx/libmaxxeffect-cembedded.so:system/lib/soundfx/libmaxxeffect-cembedded.so

# Custom XoplaX Packages
PRODUCT_PACKAGES += \
    KernelAdiutor \
    XOSWallpapers

# ChameleonOS Screen recorder
PRODUCT_PACKAGES += \
    ScreenRecorder \
    libscreenrecorder

# SuperSu Flasher
PRODUCT_COPY_FILES += \
    vendor/xoplax/prebuilt/common/bin/supersuflasher.sh:system/bin/supersuflasher.sh

# T-Mobile theme engine
include vendor/xoplax/config/themes_common.mk

# Required CM packages
PRODUCT_PACKAGES += \
    Development \
    LatinIME \
    BluetoothExt

# Optional CM packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji

# Custom CM packages
PRODUCT_PACKAGES += \
    Launcher3 \
    Trebuchet \
    DSPManager \
    libcyanogen-dsp \
    audio_effects.conf \
    Apollo \
    CMFileManager \
    LockClock \
    CMUpdater \
    CMAccount \
    CMHome

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in CM
PRODUCT_PACKAGES += \
    libsepol \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)

PRODUCT_PACKAGES += \
    procmem \
    procrank \
    Superuser \
    su

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=1
else

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

endif

PRODUCT_PACKAGE_OVERLAYS += vendor/xoplax/overlay/common

#PRODUCT_VERSION_MAJOR = 11
#PRODUCT_VERSION_MINOR = 0
#PRODUCT_VERSION_MAINTENANCE = 1-IP1

# Set CM_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef CM_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "CM_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^CM_||g')
        CM_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(CM_BUILDTYPE)),)
    CM_BUILDTYPE :=
endif

ifdef CM_BUILDTYPE
    ifneq ($(CM_BUILDTYPE), EXPERIMENTAL)
        ifdef CM_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            CM_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from CM_EXTRAVERSION
            CM_EXTRAVERSION := $(shell echo $(CM_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to CM_EXTRAVERSION
            CM_EXTRAVERSION := -$(CM_EXTRAVERSION)
        endif
    else
        ifndef CM_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            CM_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from CM_EXTRAVERSION
            CM_EXTRAVERSION := $(shell echo $(CM_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to CM_EXTRAVERSION
            CM_EXTRAVERSION := -$(CM_EXTRAVERSION)
        endif
    endif
else
    # If CM_BUILDTYPE is not defined, set to UNOFFICIAL
    CM_BUILDTYPE := HOMEMADE
    CM_EXTRAVERSION :=
endif

ifeq ($(CM_BUILDTYPE), HOMEMADE)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        CM_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(CM_BUILDTYPE), RELEASE)
	XOPLAX_VERSION := $(PREVIEW_VERSION)-$(XOPLAX_BASE)
	CM_VERSION ?= $(XOPLAX_VERSION)
#    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
#        CM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(CM_BUILD)
#    else
#        ifeq ($(TARGET_BUILD_VARIANT),user)
#            CM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(CM_BUILD)
#        else
#            CM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(CM_BUILD)
#        endif
#    endif
else
    	XOPLAX_VERSION := $(PREVIEW_VERSION)-$(XOPLAX_BASE)
	CM_VERSION ?= $(XOPLAX_VERSION)
#    ifeq ($(PRODUCT_VERSION_MINOR),0)
#        CM_VERSION := $(PRODUCT_VERSION_MAJOR)-$(shell date -u +%Y%m%d)-$(CM_BUILDTYPE)$(CM_EXTRAVERSION)-$(CM_BUILD)
#    else
#        CM_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(CM_BUILDTYPE)$(CM_EXTRAVERSION)-$(CM_BUILD)
#    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.cm.version=$(XOPLAX_VERSION) \
  ro.cm.releasetype=$(CM_BUILDTYPE) \
  ro.modversion=$(XOPLAX_VERSION) \
  ro.cmlegal.url=https://cyngn.com/legal/privacy-policy

-include vendor/cm-priv/keys/keys.mk

XOPLAX_DISPLAY_VERSION := $(XOPLAX_VERSION)
CM_DISPLAY_VERSION ?= $(XOPLAX_DISPLAY_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
  ifneq ($(CM_BUILDTYPE), UNOFFICIAL)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
      ifneq ($(CM_EXTRAVERSION),)
        # Remove leading dash from CM_EXTRAVERSION
        CM_EXTRAVERSION := $(shell echo $(CM_EXTRAVERSION) | sed 's/-//')
        TARGET_VENDOR_RELEASE_BUILD_ID := $(CM_EXTRAVERSION)
      else
        TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
      endif
    else
      TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
    endif
    CM_DISPLAY_VERSION=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)
  endif
endif
endif

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

PRODUCT_PROPERTY_OVERRIDES += \
  ro.cm.display.version=$(CM_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
