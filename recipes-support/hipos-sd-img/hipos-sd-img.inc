# SPDX-License-Identifier: MIT
# Copyright (C) 2026 iris-GmbH infrared & intelligent sensors

LICENSE = "MIT"

IMAGENAME = "${@ d.getVar('PN').replace('-sd-img','')}"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "\
    coreutils-native \
    e2fsprogs-native \
    parted-native \
"

PROVISIONING_FITIMAGE_TASKS ?= "hipos-fitimage-${MACHINE}-provisioning:do_deploy"
PROVISIONING_FITIMAGE_TASKS:himx0294 = "\
    hipos-fitimage-himx0294-provisioning:do_deploy \
    hipos-fitimage-himx0432-provisioning:do_deploy \
"

inherit deploy

# Depend on the bundle that contains bootloader, fitimage and rootfs image
# also depend on provisioning fitimage
do_compile[depends] = " \
    ${IMAGENAME}-bundle:do_install \
    ${PROVISIONING_FITIMAGE_TASKS} \
"

do_configure[noexec] = "1"
do_install[noexec] = "1"
do_package[noexec] = "1"
do_packagedata[noexec] = "1"
deltask package_write_ipk
deltask package_write_deb
deltask package_write_rpm

BOOTLOADER_LIST = "${UBOOT_SIGNED}"
BOOTLOADER_OFFSET = "1024"
BOOTLOADER_FILE_TEMPLATE = "u-boot-dtb.imx-XXXXX.signed"

PART1_OFFSET_MB = "12"
PART1_SIZE_MB = "128"

PART2_OFFSET_MB = "140"
PART2_SIZE_MB = "128"

PART3_OFFSET_MB = "268"
PART3_SIZE_MB = "128"

PART4_OFFSET_MB = "396"

FITIMAGE_PROVISIONING_FILE = "fitImage-hipos-fitimage-${MACHINE}-provisioning-${MACHINE}.signed"
FITIMAGE_FILE = "fitImage-hipos-fitimage-${MACHINE}-${MACHINE}.signed"

ROOTFS_VERITY_GZ = "${IMAGENAME}-${MACHINE}.rootfs.ext4.verity.gz"
ROOTFS_VERITY_HASHDEVICE = "${IMAGENAME}-${MACHINE}.rootfs.ext4.hashdevice"
ROOTFS_VERTIY_ROOTHASH = "${IMAGENAME}-${MACHINE}.rootfs.ext4.roothash"
ROOTFS_VERITY_ROOTHASH_SIGNATURE = "${IMAGENAME}-${MACHINE}.rootfs.ext4.roothash.signature"

DISK_IMG_FILE_TEMPLATE = "${PN}-XXXXX.img"

python do_compile() {
    import os
    import shutil
    import subprocess

    image_dir = d.getVar("DEPLOY_DIR_IMAGE")
    build_dir = d.getVar("B")
    boot_dir = os.path.join(build_dir, "p1")
    artifact_dir = os.path.join(build_dir, "p4")
    disk_img = os.path.join(build_dir, "disk.img")

    def prepare_disk_image(disk_img, img_size):
        if os.path.isfile(disk_img):
            os.remove(disk_img)
        subprocess.run(["truncate", "--size", str(img_size), disk_img])
        subprocess.run(
            ["sfdisk", disk_img],
            input=(
                "label: mbr\n"
                f"start={d.getVar('PART1_OFFSET_MB')}M, size={d.getVar('PART1_SIZE_MB')}M\n"
                f"start={d.getVar('PART2_OFFSET_MB')}M, size={d.getVar('PART2_SIZE_MB')}M\n"
                f"start={d.getVar('PART3_OFFSET_MB')}M, size={d.getVar('PART3_SIZE_MB')}M\n"
                f"start={d.getVar('PART4_OFFSET_MB')}M\n"
            ),
            text=True,
            check=True,
        )

    def prepare_boot_dir(boot_dir):
        shutil.rmtree(boot_dir, ignore_errors=True)
        os.makedirs(boot_dir)
        shutil.copyfile(os.path.join(image_dir, d.getVar("FITIMAGE_PROVISIONING_FILE")),
            os.path.join(boot_dir, "fitImage.signed"))

    def prepare_artifact_dir(artifact_dir):
        shutil.rmtree(artifact_dir, ignore_errors=True)
        os.makedirs(artifact_dir)
        shutil.copyfile(os.path.join(image_dir, d.getVar("FITIMAGE_FILE")),
            os.path.join(artifact_dir, "fitImage.signed"))
        shutil.copyfile(os.path.join(image_dir, d.getVar("ROOTFS_VERITY_GZ")),
            os.path.join(artifact_dir, "rootfs.ext4.verity.gz"))
        shutil.copyfile(os.path.join(image_dir, d.getVar("ROOTFS_VERITY_HASHDEVICE")),
            os.path.join(artifact_dir, "rootfs.ext4.hashdevice"))
        shutil.copyfile(os.path.join(image_dir, d.getVar("ROOTFS_VERTIY_ROOTHASH")),
            os.path.join(artifact_dir, "rootfs.ext4.roothash"))
        shutil.copyfile(os.path.join(image_dir, d.getVar("ROOTFS_VERITY_ROOTHASH_SIGNATURE")),
            os.path.join(artifact_dir, "rootfs.ext4.roothash.signature"))

    def get_artifact_size(artifact_dir):
        artifacts = [os.path.join(artifact_dir, f) for f in os.listdir(artifact_dir)]
        return int((sum(os.path.getsize(f) for f in artifacts) * 1.2) / (1024 * 1024))

    def copy_to_offset(source, target, offset):
        with open(source, 'rb') as s:
            data = s.read()
        with open(target, 'r+b') as t:
            t.seek(offset)
            t.write(data)

    def create_ext4(target, offset_mb, size_mb=None, source_dir=None):
        offset_byte = int(offset_mb) * 1024 * 1024
        cmd = ["mkfs.ext4", "-E", f"offset={offset_byte:d}"]
        if source_dir:
            cmd += ["-d", source_dir]
        cmd += [target]
        if size_mb:
            cmd += [f"{size_mb}M"]
        subprocess.run(cmd)

    prepare_boot_dir(boot_dir)
    prepare_artifact_dir(artifact_dir)
    img_size = (int(d.getVar("PART4_OFFSET_MB")) + get_artifact_size(artifact_dir)) * 1024 * 1024

    for conf in d.getVar("BOOTLOADER_LIST").split():
        disk_img = d.getVar("DISK_IMG_FILE_TEMPLATE").replace("XXXXX", conf)
        bootloader_file = os.path.join(image_dir, d.getVar("BOOTLOADER_FILE_TEMPLATE").replace("XXXXX", conf))

        prepare_disk_image(disk_img, img_size)
        copy_to_offset(bootloader_file, disk_img, 1024)
        create_ext4(disk_img, d.getVar('PART1_OFFSET_MB'), d.getVar('PART1_SIZE_MB'), boot_dir)
        create_ext4(disk_img, d.getVar('PART2_OFFSET_MB'), d.getVar('PART2_SIZE_MB'))
        create_ext4(disk_img, d.getVar('PART3_OFFSET_MB'), d.getVar('PART3_SIZE_MB'))
        create_ext4(disk_img, d.getVar('PART4_OFFSET_MB'), source_dir=artifact_dir)
}

do_deploy () {
    install -d ${DEPLOYDIR}/
    install -m 755 ${B}/*.img ${DEPLOYDIR}/
}
addtask deploy before do_populate_sysroot after do_compile
