#
# Copyright 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_COPY_FILES += \
	device/samsung/kanas/apns-conf.xml:system/etc/apns-conf.xml \

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/core.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# Release name
PRODUCT_RELEASE_NAME := kanas

# Custom unofficial build tag
TARGET_UNOFFICIAL_BUILD_ID := SandroidTeam

# Inherit some common CM stuff.
$(call inherit-product, vendor/aosp/config/common.mk)

# Inherit device configuration
$(call inherit-product, device/samsung/kanas/device_kanas.mk)

# Overlay
DEVICE_PACKAGE_OVERLAYS += \
	device/samsung/kanas/overlay \

# Override build date
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PACKAGES += \
	Gallery2 \
	Launcher3 \
	Stk \

# Device identifier
PRODUCT_DEVICE := kanas
PRODUCT_NAME := aosp_kanas
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G355H
PRODUCT_MANUFACTURER := samsung
PRODUCT_CHARACTERISTICS := phone
