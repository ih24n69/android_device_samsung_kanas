## Specify phone tech before including full_phone	
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# Release name
PRODUCT_RELEASE_NAME := kanas

# Inherit some common Omni stuff.
$(call inherit-product, vendor/orion/config/common.mk)

# Boot animation
TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH := 480


## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := kanas
PRODUCT_NAME := omni_kanas
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G355H
PRODUCT_MANUFACTURER := samsung
PRODUCT_CHARACTERISTICS := phone
