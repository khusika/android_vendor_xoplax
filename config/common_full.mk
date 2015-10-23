# Inherit common Xoplax stuff
$(call inherit-product, vendor/xoplax/config/common.mk)

# Include Xoplax audio files
include vendor/xoplax/config/xoplax_audio.mk

# Optional CM packages
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    SoundRecorder 

# Extra tools in CM
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar 
