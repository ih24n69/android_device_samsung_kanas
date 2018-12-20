#
# Copyright (C) 2017 The Lineage Project
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

LOCAL_PATH := $(my-dir)

define create
include $(CLEAR_VARS)
LOCAL_MODULE := $1
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
LOCAL_SRC_FILES := $1
include $(BUILD_PREBUILT)
endef

init_files := \
	init.sc8830.rc \
	init.sc8830.usb.rc \
	init.kanas3g_base.rc \
	ueventd.sc8830.rc \
	fstab.sc8830

$(foreach p,$(init_files),$(eval $(call create,$(p))))
