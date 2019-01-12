# Inherit XenonHD Stuff
$(call inherit-product, vendor/xenonhd/products/common.mk)
$(call inherit-product, device/samsung/kanas/full_kanas.mk)

PRODUCT_NAME := xenonhd_kanas
PRODUCT_DEVICE := kanas
