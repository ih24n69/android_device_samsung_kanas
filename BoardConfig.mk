# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Some magic
# on top line to make macro check scx35 common working
SOC_SCX35 := true
SF_START_GRAPHICS_ALLOCATOR_SERVICE:= true
TARGET_NEEDS_LEGACY_CAMERA_HAL1_DYN_NATIVE_HANDLE := true
USE_DEVICE_SPECIFIC_CAMERA := true

# Inherit from SCX35 common configs
-include device/samsung/scx35-common/BoardConfigCommon.mk

# Inherit from the proprietary version
-include vendor/samsung/kanas/BoardConfigVendor.mk

# Platform
ARCH_ARM_HAVE_TLS_REGISTER := true
TARGET_BOOTLOADER_BOARD_NAME := SC7735S
TARGET_BOARD_PLATFORM_GPU := mali-400 MP

# Enable privacy guard's su
WITH_SU := true

# Img configuration
BOARD_BOOTIMAGE_PARTITION_SIZE := 15728640
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 15728640
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1195376640
BOARD_USERDATAIMAGE_PARTITION_SIZE := 2415919104
BOARD_CACHEIMAGE_PARTITION_SIZE := 125829120
BOARD_FLASH_BLOCK_SIZE := 4096
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_HAS_LARGE_FILESYSTEM := true

# Wifi
BOARD_WLAN_DEVICE := bcmdhd
BOARD_WLAN_DEVICE_REV := bcm4330
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_bcmdhd
WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/dhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/dhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_STA := "/vendor/etc/wifi/bcmdhd_sta.bin"
WIFI_DRIVER_FW_PATH_AP := "/vendor/etc/wifi/bcmdhd_apsta.bin"
WIFI_DRIVER_NVRAM_PATH_PARAM := "/sys/module/dhd/parameters/nvram_path"
WIFI_DRIVER_NVRAM_PATH := "/vendor/etc/wifi/nvram_net.txt"
WIFI_BAND := 802_11_ABG
BOARD_HAVE_SAMSUNG_WIFI := true

# Graphics
USE_OVERLAY_COMPOSER_GPU := false
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
BOARD_GLOBAL_CFLAGS += -DUSE_3_FRAMEBUFFER
USE_SPRD_DITHER := false

# Audio
BOARD_USE_LIBATCHANNEL_WRAPPER := true
BOARD_USES_SS_VOIP := true

# Bootanimation
TARGET_BOOTANIMATION_HALF_RES := true

# Bluetooth
BOARD_CUSTOM_BT_CONFIG := device/samsung/kanas/bluetooth/libbt_vndcfg.txt
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/samsung/kanas/bluetooth

# Kernel
BOARD_KERNEL_CMDLINE := console=ttyS1,115200n8 androidboot.selinux=permissive androidboot.hardware=sc8830
BOARD_KERNEL_PAGESIZE := 2048
TARGET_KERNEL_CONFIG := lineageos_oreo_kanas_defconfig
TARGET_KERNEL_SOURCE := kernel/samsung/kanas
BOARD_KERNEL_IMAGE_NAME := zImage

# Assert
TARGET_OTA_ASSERT_DEVICE := kanas,kanas3g,kanas3gxx,kanas3gub,kanas3gnfcxx,kanas3gnfc,SM-G355H,SM-G355HN,SM-G355M

# Low memory config
MALLOC_SVELTE := true

# Tell vold that we have a kernel based impl of exfat
TARGET_KERNEL_HAVE_EXFAT := true

# Remove "system.new.dat" format.System files are now in "system" folder of the ROM Package.(Easy for development purpose)
BLOCK_BASED_OTA := false

# Enable dex-preoptimization to speed up the first boot sequence
# WITH_DEXPREOPT := true
# WITH_DEXPREOPT_PIC := true

# Camera
CAMERA_SUPPORT_SIZE := 5M
TARGET_BOARD_CAMERA_FLASH_CTRL := true
TARGET_BOARD_CAMERA_USE_IOMMU := true
TARGET_BOARD_CAMERA_DMA_COPY := true
TARGET_BOARD_BACK_CAMERA_INTERFACE := ccir
TARGET_BOARD_FRONT_CAMERA_INTERFACE := ccir
TARGET_BOARD_CAMERA_CAF := true
CONFIG_CAMERA_ISP := true
TARGET_HAS_LEGACY_CAMERA_HAL1 := true
TARGET_BOARD_CAMERA_ROTATION_CAPTURE := false
TARGET_BOARD_CAMERA_HAL_VERSION := HAL1.0
BOARD_GLOBAL_CFLAGS += -DCONFIG_CAMERA_ISP

# Shims
TARGET_LD_SHIM_LIBS := \
    /system/vendor/lib/hw/camera.sc8830.so|libmemoryheapion.so \
    /system/vendor/lib/hw/camera2.sc8830.so|libmemoryheapion.so \
    /system/vendor/bin/gpsd|libgps_shim.so \

# Sensors
TARGET_USES_SENSORS_WRAPPER := true

# Recovery
BOARD_HAS_DOWNLOAD_MODE := true
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_RECOVERY_FSTAB := device/samsung/kanas/rootdir/fstab.sc8830
