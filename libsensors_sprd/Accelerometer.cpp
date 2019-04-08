/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <fcntl.h>
#include <errno.h>
#include <math.h>
#include <poll.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/select.h>
#include <cutils/log.h>
#include <string.h>

#include "Accelerometer.h"

#define ACC_UNIT_CONVERSION(value) ((value) * GRAVITY_EARTH / (1024.0f))
#define ACC_INPUT_NAME  "accelerometer_sensor"
#define LOG_TAG "Sensors"
#define SIG_MOTION "en_sig_motion"

#define DEBUG 1

//TODO: Check whether poll_delay is writable when enable is 0

int write_sys_attribute(const char *path, const char *value, int bytes)
{
	int ifd, amt;

	ifd = open(path, O_WRONLY);
	if (ifd < 0) {
		ALOGE("Write_attr failed to open %s (%s)",path, strerror(errno));
		return -1;
	}

	amt = write(ifd, value, bytes);
	amt = ((amt == -1) ? -errno : 0);
	ALOGE_IF(amt < 0, "Write_int failed to write %s (%s)",
		 path, strerror(errno));
	close(ifd);
	return amt;
}
/*****************************************************************************/

Accelerometer::Accelerometer() :
	SensorBase(NULL, ACC_INPUT_NAME),
		mEnabled(0),
		mDelay(60000000),
		//mLayout(1),
    	mInputReader(32)
{
	memset(mGravity, 0, sizeof(float) * 3);
	mPendingEvents[Main].version = sizeof(sensors_event_t);
	mPendingEvents[Main].sensor = ID_A;
	mPendingEvents[Main].type = SENSOR_TYPE_ACCELEROMETER;
	memset(mPendingEvents[Main].data, 0, sizeof(((sensors_event_t *)NULL)->data));

	mPendingEvents[SignificantMotion].version = sizeof(sensors_event_t);
	mPendingEvents[SignificantMotion].sensor = ID_SM;
	mPendingEvents[SignificantMotion].type = SENSOR_TYPE_SIGNIFICANT_MOTION;
	memset(mPendingEvents[SignificantMotion].data, 0, sizeof(((sensors_event_t *)NULL)->data));
	/* Do this once and only send this multiple times; save I/O */
	mPendingEvents[SignificantMotion].data[0] = 1;

	mPendingEvents[LinearAcceleration].version = sizeof(sensors_event_t);
	mPendingEvents[LinearAcceleration].sensor = ID_LA;
	mPendingEvents[LinearAcceleration].type = SENSOR_TYPE_LINEAR_ACCELERATION;
	memset(mPendingEvents[LinearAcceleration].data, 0, sizeof(((sensors_event_t *)NULL)->data));

	if (data_fd >= 0) {
		strcpy(input_sysfs_path, "/sys/class/input/");
		strcat(input_sysfs_path, input_name);
		strcat(input_sysfs_path, "/device/");
		input_sysfs_path_len = strlen(input_sysfs_path);
		ALOGD("Accelerometer: sysfs_path=%s", input_sysfs_path);
	} else {
		input_sysfs_path[0] = '\0';
		input_sysfs_path_len = 0;
	}

	open_device();
}

Accelerometer::~Accelerometer()
{
	if (mEnabled & (1<<Main)) {
		setEnable(ID_A, 0);
	}
	if (mEnabled & (1<<LinearAcceleration)) {
		setEnable(ID_LA, 0);
	}
	if (mEnabled & (1<<SignificantMotion)) {
		setEnable(ID_SM, 0);
	}

	close_device();
}

int Accelerometer::setEnable(int32_t handle, int enabled)
{
	int err = 0;
	char buffer[2]={0,0};
	char const *enable_file = "enable";

	/* handle check */
	switch (handle) {
		case ID_A:
			ALOGD("Accelerometer: enabled = %d", enabled);
			if (enabled)
				mEnabled |= (1<<Main);
			else
				mEnabled &= ~(1<<Main);
		break;
		case ID_SM:
			ALOGD("Accelerometer: Significant Motion enabled = %d", enabled);
			enable_file = SIG_MOTION; // write to this file instead
			if (enabled)
				mEnabled |= (1<<SignificantMotion);
			else
				mEnabled &= ~(1<<SignificantMotion);
		break;
		case ID_LA:
			ALOGD("Accelerometer: Linear Acceleration enabled = %d", enabled);
			if (enabled)
				mEnabled |= (1<<LinearAcceleration);
			else
				mEnabled &= ~(1<<LinearAcceleration);
		break;
		default:
			ALOGE("Accelerometer: Invalid handle (%d)", handle);
			return -EINVAL;

	}

	ALOGD("Accelerometer: Enabled Sensors bitmask (%d)", mEnabled);

	buffer[0] = mEnabled ? '1':'0';
	strcpy(&input_sysfs_path[input_sysfs_path_len], enable_file);
	err = write_sys_attribute(input_sysfs_path, buffer, 1);

	return err;
}

int Accelerometer::setDelay(int32_t handle, int64_t delay_ns)
{
	int err = 0;
	int32_t us; 
	char buffer[16];
	int bytes;

	/* handle check */
	switch (handle) {
		case ID_SM: return 0;
		case ID_LA:
		case ID_A: break;
		default:
			ALOGE("Accelerometer: Invalid handle (%d)", handle);
		return -EINVAL;
	}

	if (mDelay != delay_ns) {
		us = (int32_t)(delay_ns / 1000000);

		strcpy(&input_sysfs_path[input_sysfs_path_len], "poll_delay");
		bytes = sprintf(buffer, "%d", (int)us);
		err = write_sys_attribute(input_sysfs_path, buffer, bytes);
		if (err == 0) {
			mDelay = delay_ns;
			ALOGD("Accelerometer: Control set delay %f ms requetsed, ",
			      delay_ns/1000000.0f);
		}
	}
	return err;
}

int64_t Accelerometer::getDelay(int32_t handle)
{
	return (handle == ID_A || handle == ID_LA) ? mDelay : 0;
}

int Accelerometer::getEnable(int32_t handle)
{
	switch (handle) {
		case ID_A: return !!(mEnabled & (1<<Main));
		case ID_LA: return !!(mEnabled & (1<<LinearAcceleration));
		case ID_SM: return !!(mEnabled & (1<<SignificantMotion));
	}
	return 0;
}

int Accelerometer::readEvents(sensors_event_t * data, int count)
{
	if (count < 1)
		return -EINVAL;

	ssize_t n = mInputReader.fill(data_fd);
	if (n < 0)
		return n;

	int numEventReceived = 0;
	input_event const* event;

	int sensorId = ID_A;
	while (mFlushed) {
		if (mFlushed & (1 << sensorId)) { /* Send flush META_DATA_FLUSH_COMPLETE immediately */
			sensors_event_t sensor_event;
			memset(&sensor_event, 0, sizeof(sensor_event));
			sensor_event.version = META_DATA_VERSION;
			sensor_event.type = SENSOR_TYPE_META_DATA;
			sensor_event.meta_data.sensor = sensorId;
			sensor_event.meta_data.what = 0;
			*data++ = sensor_event;
			count--;
			numEventReceived++;
			mFlushed &= ~(0x01 << sensorId);
			ALOGD_IF(DEBUG, "Accelerometer: %s Flushed sensorId: %d", __func__, sensorId);
		}
		sensorId++;
	}

	while (count && mInputReader.readEvent(&event)) {
		int type = event->type;
		if (type == EV_REL) {
			float value = ACC_UNIT_CONVERSION(event->value);
			if (event->code == EVENT_TYPE_ACCEL_X) {
				mPendingEvents[Main].acceleration.x = value;
				if (mEnabled & ((1 << LinearAcceleration) | (1 << SignificantMotion))) {
					mGravity[0] = alpha * mGravity[0] + (1 - alpha) * value;
					mPendingEvents[LinearAcceleration].acceleration.x =
					        value - mGravity[0];
				}
			} else if (event->code == EVENT_TYPE_ACCEL_Y) {
				mPendingEvents[Main].acceleration.y = value;
				if (mEnabled & ((1 << LinearAcceleration) | (1 << SignificantMotion))) {
					mGravity[1] = alpha * mGravity[1] + (1 - alpha) * value;
					mPendingEvents[LinearAcceleration].acceleration.y =
					        value - mGravity[1];
				}
			} else if (event->code == EVENT_TYPE_ACCEL_Z) {
				mPendingEvents[Main].acceleration.z = value;
				if (mEnabled & ((1 << LinearAcceleration) | (1 << SignificantMotion))) {
					mGravity[2] = alpha * mGravity[2] + (1 - alpha) * value;
					mPendingEvents[LinearAcceleration].acceleration.z =
					        value - mGravity[2];
				}
			}
		} else if (type == EV_MSC && event->code == MSC_GESTURE) {
			/* SMD sensor is a one shot sensor and disables itself
			 * after firing. Make sure the bitmask exposes this behavior
			 */
			mEnabled &= ~(1<<SignificantMotion);
			ALOGD_IF(DEBUG, "Accelerometer: Significant Motion occured!");

			/* Because it only fires up one event, we can simply send it */
			mPendingEvents[SignificantMotion].timestamp = timevalToNano(event->time);
			*data++ = mPendingEvents[SignificantMotion];
			count--;
			numEventReceived++;
		} else if (type == EV_SYN) {
			// ACK event when sensor is enabled, ignore otherwise.
			if (mEnabled & (1<<Main)) {
				mPendingEvents[Main].timestamp = timevalToNano(event->time);
				*data++ = mPendingEvents[Main];

				count--;
				numEventReceived++;
			}
			if (mEnabled & (1<<LinearAcceleration)) {
				mPendingEvents[LinearAcceleration].timestamp = timevalToNano(event->time);
				*data++ = mPendingEvents[LinearAcceleration];

				count--;
				numEventReceived++;
			}
		} else {
			ALOGE("Accelerometer: unknown event (type=%d, code=%d)",
			      type, event->code);
		}
		mInputReader.next();
	}

	return numEventReceived;
}

int Accelerometer::batch(int handle, int flags, int64_t period_ns, int64_t timeout) {
	(void)flags;
	(void)timeout;
	if (mEnabled) {
		setDelay(handle, period_ns);
	}
	return 0;
}

int Accelerometer::flush(int handle)
{
	if (mEnabled) {
		mFlushed |= (1 << handle);
		ALOGD("Accelerometer: %s: handle: %d", __func__, handle);
		return 0;
	}
	return -EINVAL;
}
