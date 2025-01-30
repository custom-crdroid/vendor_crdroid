#!/bin/bash
#
# Copyright (C) 2024-25 Matrixx Android Project
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
#

#$1=TARGET_DEVICE, $2=PRODUCT_OUT, $3=LINEAGE_VERSION
existingOTAjson=./vendor/MatrixxOTA/$1.json
output=./vendor/MatrixxOTA/$1.json

buildprop=$2/system/build.prop

if [ -f "$existingOTAjson" ]; then
    # Get data from already existing device JSON
    maintainer=$(grep -n "\"maintainer\"" "$existingOTAjson" | cut -d ":" -f 3 | sed 's/"//g' | sed 's/,//g' | xargs)
    oem=$(grep -n "\"oem\"" "$existingOTAjson" | cut -d ":" -f 3 | sed 's/"//g' | xargs)
    device=$(grep -n "\"device\"" "$existingOTAjson" | cut -d ":" -f 3 | sed 's/"//g' | xargs)
else
    # Fetch Basic details from build.prop if JSON doesn't exist
    maintainer=$(grep "ro.matrixx.maintainer" "$BUILDPROP" | cut -d'=' -f2 | xargs)
    oem=$(grep "ro.product.system.manufacturer" "$BUILDPROP" | cut -d'=' -f2 | xargs)
    device=$(basename "$2")
fi

filename=$3
download="https://sourceforge.net/projects/projectmatrixx/files/Android-15/$1/$filename/download"
linenr=$(grep -n "ro.system.build.date.utc" "$buildprop" | cut -d':' -f1)
timestamp=$(sed -n "$linenr"p < "$buildprop" | cut -d'=' -f2)
md5=$(md5sum "$2/$3" | cut -d' ' -f1)
size=$(stat -c "%s" "$2/$3")

#Get version
VERSION=$(echo "$3" | cut -d'-' -f6 | sed 's/v//')
IFS='.' read -r V_MAX V_MIN V_PATCH <<< "$VERSION"
if [[ -z "$V_PATCH" ]]; then
  VERSION="$V_MAX.$V_MIN"
else
  VERSION="$V_MAX.$V_MIN.$V_PATCH"
fi

	#cleanup old file
	if [ -f $output ]; then
        	rm $output
	fi

	echo '{
  "response": [
    {
        "maintainer": "'$maintainer'",
        "oem": "'$oem'",
        "device": "'$device'",
        "filename": "'$filename'",
        "download": "'$download'",
        "timestamp": '$timestamp',
        "md5": "'$md5'",
        "size": '$size',
        "version": "'$version'"
    }
  ]
}' >> $output

        echo "vendor/MatrixxOTA/$1.json"
else
	#if not already supported, create dummy file with info in it on how to
	echo 'There is no official support for this device yet' >> $output;
fi

echo ""