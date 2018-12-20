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

#ifndef ANDROID_BOSCH_SENSOR_H
#define ANDROID_BOSCH_SENSOR_H

#include <stdint.h>
#include <errno.h>
#include <sys/cdefs.h>
#include <sys/types.h>

#include "sensors.h"
#include "SensorBase.h"
#include "InputEventReader.h"

/*****************************************************************************/

struct input_event;

class Accelerometer : public SensorBase {
    enum {
        Main               = 0,
        LinearAcceleration = 1,
        SignificantMotion  = 2,
        numSensors,
    };

    /* mEnabled is now a bit mask. */
    int mEnabled;

    int64_t mDelay;
    uint32_t mFlushed;
    sensors_event_t mPendingEvents[numSensors];
    InputEventCircularReader mInputReader;
    char input_sysfs_path[PATH_MAX];
    int input_sysfs_path_len;

    // For Linear Acceleration
    const float alpha = 0.8f;
    float mGravity[3];

public:
            Accelerometer();
    virtual ~Accelerometer();
    virtual int readEvents(sensors_event_t* data, int count);
    virtual int setDelay(int32_t handle, int64_t ns);
    virtual int setEnable(int32_t handle, int enabled);
    virtual int64_t getDelay(int32_t handle);
    virtual int getEnable(int32_t handle);
    virtual int flush(int handle);
    virtual int batch(int handle, int flags, int64_t period_ns, int64_t timeout);
};

/*****************************************************************************/

#endif  // ANDROID_BOSCH_SENSOR_H
