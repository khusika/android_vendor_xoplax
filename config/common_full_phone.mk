# Inherit common XOS stuff
$(call inherit-product, vendor/xoplax/config/common_full.mk)

# Required XOS packages
PRODUCT_PACKAGES += \
    LatinIME

# Include XOS LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/xoplax/overlay/dictionaries

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=aerodynamics.ogg

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/xoplax/prebuilt/common/bootanimation/480.zip:system/media/bootanimation.zip
endif

$(call inherit-product, vendor/xoplax/config/telephony.mk)
