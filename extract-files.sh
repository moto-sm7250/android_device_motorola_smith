#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
    # Patch configureRpcThreadpool
    vendor/lib64/vendor.qti.hardware.camera.postproc@1.0-service-impl.so)
        "${SIGSCAN}" -p "CC 0A 00 94" -P "1F 20 03 D5" -f "${2}"
        ;;
    # memset shim
    vendor/bin/charge_only_mode)
        "${PATCHELF}" --print-needed "${2}" |grep -q libmemset_shim || "${PATCHELF}" --add-needed libmemset_shim.so "${2}"
        ;;
    # rename moto modified tinyalsa
    vendor/lib/libtinyalsa-moto.so | vendor/lib64/libtinyalsa-moto.so)
        "${PATCHELF}" --set-soname libtinyalsa-moto.so "${2}"
        ;;
    # rename moto modified tinyalsa
    vendor/lib/motorola.hardware.audio.adspd@1.0-impl.so | vendor/lib64/motorola.hardware.audio.adspd@1.0-impl.so)
        "${PATCHELF}" --replace-needed libtinyalsa.so libtinyalsa-moto.so "${2}"
        ;;
    # __lttf2 shim
    vendor/lib64/libvidhance.so)
        "${PATCHELF}" --print-needed "${2}" |grep -q libcomparetf2_shim || "${PATCHELF}" --add-needed libcomparetf2_shim.so "${2}"
        ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=smith
export DEVICE_COMMON=sm7250-common
export VENDOR=motorola
export VENDOR_COMMON=${VENDOR}

"./../../${VENDOR_COMMON}/${DEVICE_COMMON}/extract-files.sh" "$@"
