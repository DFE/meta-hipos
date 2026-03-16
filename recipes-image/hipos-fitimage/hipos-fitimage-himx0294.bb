# SPDX-License-Identifier: MIT
# Copyright (C) 2025 iris-GmbH infrared & intelligent sensors

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit fitimage hab-signed-fitimage

include himx0294.inc

FITIMAGE_IMAGE_ramdisk ?= "hipos-initramfs-image"
