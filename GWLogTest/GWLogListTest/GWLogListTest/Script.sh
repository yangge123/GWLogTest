#!/bin/sh

#  Script.sh
#  GWLogListTest
#
#  Created by yangye on 16/10/31.
#  Copyright © 2016年 gowild. All rights reserved.
# Sets the target folders and the final framework product.

FMK_NAME=${PROJECT_NAME}

INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework


WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework



xcodebuild -configuration "Release" -target"${FMK_NAME}" -sdk iphoneos clean build
xcodebuild -configuration "Release" -target"${FMK_NAME}" -sdk iphonesimulator clean build


if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"

cp -R "${DEVICE_DIR}/""${INSTALL_DIR}/"


lipo -create "${DEVICE_DIR}/${FMK_NAME}""${SIMULATOR_DIR}/${FMK_NAME}" -output"${INSTALL_DIR}/${FMK_NAME}"

rm -r "${WRK_DIR}"

open "${SRCROOT}/Products/"
