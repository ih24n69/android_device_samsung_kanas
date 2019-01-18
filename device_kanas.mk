#
# Copyright (C) 2016 The Android Open Source Project
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

# Inherit from vendor
$(call inherit-product, vendor/samsung/kanas/kanas-vendor.mk)

# Add our overlay first as a matter of precedence
DEVICE_PACKAGE_OVERLAYS += device/samsung/kanas/overlay

# Inherit from scx35-common device configuration
$(call inherit-product, device/samsung/scx35-common/common.mk)

# Boot animation
TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH := 480

# Rootdir files
PRODUCT_PACKAGES += \
	init.sc8830.rc \
	init.sc8830.usb.rc \
	init.kanas3g_base.rc \
	ueventd.sc8830.rc \
	fstab.sc8830

# RIL
PRODUCT_PACKAGES += \
	rild.rc

# RIL
PRODUCT_PACKAGES += \
	modemd \
	nvitemd \
	refnotify \

# Keylayouts
KEYLAYOUT_FILES := \
	device/samsung/kanas/keylayouts/ist30xx_ts_input.kl \
	device/samsung/kanas/keylayouts/sci-keypad.kl

PRODUCT_COPY_FILES += \
	$(foreach f,$(KEYLAYOUT_FILES),$(f):system/usr/keylayout/$(notdir $(f)))

# WiFi
$(call inherit-product, hardware/broadcom/wlan/bcmdhd/config/config-bcm.mk)

# Codecs
PRODUCT_PACKAGES += \
	libstagefright_sprd_soft_mpeg4dec \
	libstagefright_sprd_soft_h264dec

# Reverse-engineered HAL driver
PRODUCT_PACKAGES += \
	sensors.sc8830

# Camera can only use HALv1
PRODUCT_PROPERTY_OVERRIDES += \
	media.stagefright.legacyencoder=true \
	media.stagefright.less-secure=true

# Sdcardfs
PRODUCT_PROPERTY_OVERRIDES += \
	ro.sys.sdcardfs=true

# Some Lineageos Apps
PRODUCT_PACKAGES += \
       Snap

# MDNIE - modified for this device
PRODUCT_PACKAGES += \
	AdvancedDisplay-mod

# ART device props
PRODUCT_PROPERTY_OVERRIDES += \
	dalvik.vm.dex2oat-filter=interpret-only \
	dalvik.vm.image-dex2oat-filter=speed

# Configuration overrides: these are not bundled with an Android.mk since they
# need to supersede/override all instances.
MEDIA_CONFIGS := \
	device/samsung/kanas/configs/media/media_codecs.xml \
	device/samsung/kanas/configs/media/media_profiles.xml

AUDIO_CONFIGS := \
	device/samsung/kanas/configs/audio/audio_hw.xml \
	device/samsung/kanas/configs/audio/audio_para \
	device/samsung/kanas/configs/audio/audio_policy.conf\
	device/samsung/kanas/configs/audio/codec_pga.xml \
	device/samsung/kanas/configs/audio/tiny_hw.xml

INIT_FILES := \
	device/samsung/kanas/configs/media/mediaserver.rc

PRODUCT_COPY_FILES += \
	$(foreach f,$(MEDIA_CONFIGS),$(f):system/etc/$(notdir $(f))) \
	$(foreach f,$(AUDIO_CONFIGS),$(f):system/etc/$(notdir $(f))) \
	$(foreach f,$(INIT_FILES),$(f):system/etc/init/$(notdir $(f)))
