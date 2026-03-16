# SPDX-License-Identifier: MIT
# Copyright (C) 2025 iris-GmbH infrared & intelligent sensors

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit fitimage hab-signed-fitimage

FITIMAGE_IMAGES = "kernel fdt ramdisk"

FITIMAGE_LOADADDRESS ?= "0x83800000"
FITIMAGE_ENTRYPOINT  ?= "0x83800000"
FITIMAGE_DTB_LOADADDRESS ?= "0x83000000"

FITIMAGE_IMAGE_kernel ?= "virtual/kernel"
FITIMAGE_IMAGE_kernel[type] ?= "kernel"

FITIMAGE_IMAGE_fdt ?= "virtual/kernel"
FITIMAGE_IMAGE_fdt[type] ?= "fdt"
FITIMAGE_IMAGE_fdt[file] = "\
	${DEPLOY_DIR_IMAGE}/imx6ull-himx0294-impec.dtb \
	${DEPLOY_DIR_IMAGE}/imx6ull-himx0294-impec-2.dtb \
"

FITIMAGE_IMAGE_ramdisk ?= "hipos-initramfs-image"
FITIMAGE_IMAGE_ramdisk[type] ?= "ramdisk"

COMPATIBLE_MACHINE = "himx0294"
