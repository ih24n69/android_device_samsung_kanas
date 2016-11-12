## Specify phone tech before including full_phone	
$(call inherit-product, vendor/cm/config/telephony.mk)

# Release name
PRODUCT_RELEASE_NAME := kanas

# Custom unofficial build tag
TARGET_UNOFFICIAL_BUILD_ID := SandroidTeam

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, $(LOCAL_PATH)/device_kanas.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := kanas
PRODUCT_NAME := cm_kanas
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G355H
PRODUCT_MANUFACTURER := samsung
PRODUCT_CHARACTERISTICS := phone
