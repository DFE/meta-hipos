# SPDX-License-Identifier: MIT
# Copyright (C) 2026 iris-GmbH infrared & intelligent sensors

SUMMARY = "initramfs-framework module for provisioning the hipos rootfs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
RDEPENDS:${PN} = " \
    cryptsetup \
    e2fsprogs \
    initramfs-framework-base \
    initramfs-module-lvm \
    iris-signing-pubkey \
    keyctl-caam \
    keyutils \
    openssl-bin \
    parted \
"

inherit allarch
inherit only-for-hipos-cyber-security

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "file://hiposprovisioning"

S = "${WORKDIR}"

INJECTED_ROOTPASSWORD ?= "*"

do_compile() {
    echo "INJECTED_ROOTPASSWORD='${INJECTED_ROOTPASSWORD}'" > hipos_provisioning_common.sh
}

do_install() {
    install -d ${D}/init.d
    install -m 0755 ${WORKDIR}/hiposprovisioning ${D}/init.d/70-hiposprovisioning

    install -d ${D}${datadir}
    install -m 0755 ${WORKDIR}/hipos_provisioning_common.sh ${D}${datadir}/hipos_provisioning_common.sh

}

FILES:${PN} = "\
    /init.d/70-hiposprovisioning \
    /usr/share/hipos_provisioning_common.sh \
"

# Conflict with mount script, they won't work together
RCONFLICTS:${PN} = "initramfs-module-hipos-mount"
