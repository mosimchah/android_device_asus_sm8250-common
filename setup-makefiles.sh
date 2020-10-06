#!/bin/bash
#
# Copyright (C) 2020 The LineageOS Project
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

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

AICP_ROOT="${MY_DIR}/../../.."

HELPER="${AICP_ROOT}/vendor/aicp/build/tools/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Initialize the helper for common
setup_vendor "${DEVICE_COMMON}" "${VENDOR}" "${AICP_ROOT}" true

# Copyright headers and guards
write_headers "obiwan tequila"

# The standard common blobs
write_makefiles "${MY_DIR}/proprietary-files.txt" true

# Finish
write_footers

# Reinitialize the helper for device
INITIAL_COPYRIGHT_YEAR="$DEVICE_BRINGUP_YEAR"
setup_vendor "${DEVICE}" "${VENDOR}" "${AICP_ROOT}" false

# Copyright headers and guards
write_headers

for BLOB_LIST in "${MY_DIR}"/../"${DEVICE}"/proprietary-files*.txt; do
    # The standard device blobs
    write_makefiles "${BLOB_LIST}" true
done

# Finish
write_footers
