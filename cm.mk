dev_name := SandroidTeam
tree := NIGHTLY
$(call inherit-product, vendor/cm/config/telephony.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, $(LOCAL_PATH)/device_kanas.mk)

# Release name
PRODUCT_RELEASE_NAME := kanas

# Custom unofficial build tag
TARGET_UNOFFICIAL_BUILD_ID := $(dev_name)-$(tree)

# Override build date
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Device identifier
PRODUCT_DEVICE := kanas
PRODUCT_NAME := cm_kanas
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G355H
PRODUCT_MANUFACTURER := samsung
PRODUCT_CHARACTERISTICS := phone
