# SPDX-License-Identifier: MIT
# Copyright (C) 2026 iris-GmbH infrared & intelligent sensors

LICENSE = "MIT"

IMAGENAME = "${@ d.getVar('PN').replace('-sd-preparation','')}"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# The following line forces the usage of the "files" directory next to this .inc file even if it is required from another layer
FILESEXTRAPATHS:prepend := "${@os.path.dirname(d.getVar('FILE'))}/files:"

SRC_URI = "file://hipos-prepare-sd.sh"

PROVISIONING_FITIMAGE_TASKS ?= "hipos-fitimage-${MACHINE}-provisioning:do_deploy"
PROVISIONING_FITIMAGE_TASKS:himx0294 = "\
    hipos-fitimage-himx0294-provisioning:do_deploy \
    hipos-fitimage-himx0432-provisioning:do_deploy \
"

inherit deploy

# Depend on the bundle that contains bootloader, fitimage and rootfs image
# also depend on provisioning fitimage
do_deploy[depends] = " \
    ${IMAGENAME}-bundle:do_install \
    ${PROVISIONING_FITIMAGE_TASKS} \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"

FITIMAGE_PROVISIONING_FILE = "fitImage-hipos-fitimage-${MACHINE}-provisioning-${MACHINE}.signed"
FITIMAGE_FILE = "fitImage-hipos-fitimage-${MACHINE}-${MACHINE}.signed"

ROOTFS_VERITY_GZ = "${IMAGENAME}-${MACHINE}.rootfs.ext4.verity.gz"
ROOTFS_VERITY_HASHDEVICE = "${IMAGENAME}-${MACHINE}.rootfs.ext4.hashdevice"
ROOTFS_VERTIY_ROOTHASH = "${IMAGENAME}-${MACHINE}.rootfs.ext4.roothash"
ROOTFS_VERITY_ROOTHASH_SIGNATURE = "${IMAGENAME}-${MACHINE}.rootfs.ext4.roothash.signature"

BUNDLE_NAME ?= "${IMAGENAME}-sd-preparation"

do_deploy() {
    bundle_dir="${WORKDIR}/bundle"
    artifact_dir="${bundle_dir}/artifacts"
    archive="${DEPLOYDIR}/${BUNDLE_NAME}.tar.gz"

    rm -rf "${bundle_dir}"
    install -d "${artifact_dir}"
    install -d "${DEPLOYDIR}"

    install -m 0644 "${DEPLOY_DIR_IMAGE}/${ROOTFS_VERITY_GZ}" \
        "${artifact_dir}/rootfs.ext4.verity.gz"
    install -m 0644 "${DEPLOY_DIR_IMAGE}/${ROOTFS_VERITY_HASHDEVICE}" \
        "${artifact_dir}/rootfs.ext4.hashdevice"
    install -m 0644 "${DEPLOY_DIR_IMAGE}/${ROOTFS_VERTIY_ROOTHASH}" \
        "${artifact_dir}/rootfs.ext4.roothash"
    install -m 0644 "${DEPLOY_DIR_IMAGE}/${ROOTFS_VERITY_ROOTHASH_SIGNATURE}" \
        "${artifact_dir}/rootfs.ext4.roothash.signature"

    install -m 0644 "${DEPLOY_DIR_IMAGE}/${FITIMAGE_PROVISIONING_FILE}" \
        "${artifact_dir}/fitImage.provisioning.signed"
    install -m 0644 "${DEPLOY_DIR_IMAGE}/${FITIMAGE_FILE}" \
        "${artifact_dir}/fitImage.signed"

    for type in ${UBOOT_SIGNED}; do
        bootloader="${DEPLOY_DIR_IMAGE}/u-boot-dtb.imx-${type}.signed"
        install -m 0644 "${bootloader}" "${artifact_dir}/u-boot-dtb-${type}.signed"
    done

    install -m 0755 "${WORKDIR}/hipos-prepare-sd.sh" "${bundle_dir}/"

    rm -f "${archive}"

    cd "${bundle_dir}"
    tar \
        --sort=name \
        --mtime="@${SOURCE_DATE_EPOCH}" \
        --owner=0 \
        --group=0 \
        --numeric-owner \
        -C "${bundle_dir}" \
        -czf "${archive}" \
        .
}

addtask deploy after do_unpack before do_build
