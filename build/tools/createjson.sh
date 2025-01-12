#!/bin/bash
#
# Copyright (C) 2019-2025 crDroid Android Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#$1=TARGET_DEVICE, $2=PRODUCT_OUT, $3=FILE_NAME
output=$2/$1.json

# Cleanup old file
if [ -f $output ]; then
    rm $output
fi

echo "Generating JSON file data for OTA support..."

# Define fields manually or leave them empty
MAINTAINER=""
OEM=""
DEVICE=""
BUILDTYPE=""
FORUM=""
GAPPS=""
FIRMWARE=""
MODEM=""
BOOTLOADER=""
RECOVERY=""
PAYPAL=""
TELEGRAM=""
DT=""
COMMON_DT=""
KERNEL=""

# Generate JSON fields
FILENAME=$3
VERSION=$(echo "$3" | cut -d'-' -f5 | sed 's/v//')
V_MAX=$(echo "$VERSION" | cut -d'.' -f1)
V_MIN=$(echo "$VERSION" | cut -d'.' -f2)
VERSION="$V_MAX.$V_MIN"

BUILDPROP="$2/system/build.prop"
TIMESTAMP=$(grep "ro.system.build.date.utc" "$BUILDPROP" | cut -d'=' -f2)
MD5=$(md5sum "$2/$3" | cut -d' ' -f1)
SHA256=$(sha256sum "$2/$3" | cut -d' ' -f1)
SIZE=$(stat -c "%s" "$2/$3")

# Generate JSON output
cat <<EOF >$output
{
    "response": [
        {
            "maintainer": "${MAINTAINER:-}",
            "oem": "${OEM:-}",
            "device": "${DEVICE:-}",
            "filename": "$FILENAME",
            "download": "https://sourceforge.net/projects/custom-crdroid/files/$1/$3/download",
            "timestamp": $TIMESTAMP,
            "md5": "$MD5",
            "sha256": "$SHA256",
            "size": $SIZE,
            "version": "$VERSION",
            "buildtype": "${BUILDTYPE:-}",
            "forum": "${FORUM:-}",
            "gapps": "${GAPPS:-}",
            "firmware": "${FIRMWARE:-}",
            "modem": "${MODEM:-}",
            "bootloader": "${BOOTLOADER:-}",
            "recovery": "${RECOVERY:-}",
            "paypal": "${PAYPAL:-}",
            "telegram": "${TELEGRAM:-}",
            "dt": "${DT:-}",
            "common-dt": "${COMMON_DT:-}",
            "kernel": "${KERNEL:-}"
        }
    ]
}
EOF

echo "JSON file generation completed"
