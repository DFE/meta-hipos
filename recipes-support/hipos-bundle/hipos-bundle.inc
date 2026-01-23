# SPDX-License-Identifier: MIT
# Copyright (C) 2025 iris-GmbH infrared & intelligent sensors

LICENSE = "MIT"

IMAGENAME = "${@ d.getVar('PN').replace('-bundle','')}"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# do nothing, package nothing, deploy nothing
do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
do_package[noexec] = "1"
do_packagedata[noexec] = "1"
deltask package_write_ipk
deltask package_write_deb
deltask package_write_rpm

FITIMAGE_TASKS ?= "hipos-fitimage-${MACHINE}:do_deploy"
FITIMAGE_TASKS:himx0294 = "\
    hipos-fitimage-himx0294:do_deploy \
    hipos-fitimage-himx0432:do_deploy \
"

do_install[depends] = "\
    ${IMAGENAME}:do_image_complete \
    ${FITIMAGE_TASKS} \
    virtual/bootloader:do_deploy \
"
