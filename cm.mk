## Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Release name
PRODUCT_RELEASE_NAME := kanas

# Custom unofficial build tag
TARGET_UNOFFICIAL_BUILD_ID := SandroidTeam

# Inherit device configuration
$(call inherit-product, device/samsung/kanas/kanas.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := kanas
PRODUCT_NAME := cm_kanas
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G355H
PRODUCT_MANUFACTURER := samsung
PRODUCT_CHARACTERISTICS := phone
