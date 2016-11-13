#
# Copyright (C) 2016 The CyanogenMod Project
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

# Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/telephony.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, $(LOCAL_PATH)/device_kanas.mk)

# Release name
PRODUCT_RELEASE_NAME := kanas

# Custom unofficial build tag
TARGET_UNOFFICIAL_BUILD_ID := SandroidTeam

# Override build date
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Device identifier
PRODUCT_DEVICE := kanas
PRODUCT_NAME := cm_kanas
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G355H
PRODUCT_MANUFACTURER := samsung
PRODUCT_CHARACTERISTICS := phone
