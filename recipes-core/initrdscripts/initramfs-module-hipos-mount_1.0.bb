SUMMARY = "initramfs-framework module for mounting the hipos rootfs"
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
"

inherit allarch
inherit only-for-hipos-cyber-security

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "\
    file://hiposmount \
    file://hiposencrypt \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/init.d
    install -m 0755 ${WORKDIR}/hiposencrypt ${D}/init.d/79-hiposencrypt
    install -m 0755 ${WORKDIR}/hiposmount ${D}/init.d/80-hiposmount
}

FILES:${PN} = "\
    /init.d/80-hiposmount \
    /init.d/79-hiposencrypt \
"
