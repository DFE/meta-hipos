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

do_install() {
    install -d ${D}/init.d
    install -m 0755 ${WORKDIR}/hiposprovisioning ${D}/init.d/70-hiposprovisioning
}

FILES:${PN} = "/init.d/70-hiposprovisioning"

# Conflict with mount script, they won't work together
RCONFLICTS:${PN} = "initramfs-module-hipos-mount"
