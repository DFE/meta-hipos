# SPDX-License-Identifier: MIT
# Copyright (C) 2025 iris-GmbH infrared & intelligent sensors

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit fitimage hab-signed-fitimage

FITLOADADDR ?= "0x28000000"

FITIMAGE_IMAGES = "kernel fdt ramdisk"

FITIMAGE_LOADADDRESS ?= "0x10008000"
FITIMAGE_ENTRYPOINT  ?= "0x10008000"
FITIMAGE_DTB_LOADADDRESS ?= "0x22000000"

FITIMAGE_IMAGE_kernel ?= "virtual/kernel"
FITIMAGE_IMAGE_kernel[type] ?= "kernel"

FITIMAGE_IMAGE_fdt ?= "virtual/kernel"
FITIMAGE_IMAGE_fdt[type] ?= "fdt"
FITIMAGE_IMAGE_fdt[file] = "\
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-imoc.dtb     \
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-imoc-2.dtb   \
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-ivap.dtb     \
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-dvmon.dtb    \
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-dvmon-2.dtb  \
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-dvrec.dtb    \
    ${DEPLOY_DIR_IMAGE}/imx6qp-himx0294-dvrec.dtb   \
"

FITIMAGE_IMAGE_ramdisk ?= "hipos-initramfs-image"
FITIMAGE_IMAGE_ramdisk[type] ?= "ramdisk"

COMPATIBLE_MACHINE = "himx0294"
