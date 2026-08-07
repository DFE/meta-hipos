#!/bin/sh
#
# Copyright (C) 2026 iris-GmbH infrared & intelligent sensors
#
# SPDX-License-Identifier: MIT

if [ "$#" -lt 2 ]
then
    echo "Usage: $0 [blockdevice] [himx0294 product: ivap|dvmon|imoc|ivqp]"
    exit 1
fi

dev="$1"
product="$2"
artifacts="./artifacts"

a_uboot="${artifacts}/u-boot-dtb-himx0294-${product}.signed"

if [ ! -b "${dev}" ]
then
    echo "${dev} is not a blockdevice"
    exit 1
fi

if [ ! -f "${a_uboot}" ]
then
    echo "Invalid product \"${product}\" - File not found: ${a_uboot}"
    exit 1
fi

a_fitimage="${artifacts}/fitImage.signed"
a_fitimage_provisioning="${artifacts}/fitImage.provisioning.signed"

a_rootfs_gz="${artifacts}/rootfs.ext4.verity.gz"
a_rootfs_hashdevice="${artifacts}/rootfs.ext4.hashdevice"
a_rootfs_roothash="${artifacts}/rootfs.ext4.roothash"
a_rootfs_roothash_signature="${artifacts}/rootfs.ext4.roothash.signature"

vglabel="hydralvm_provisioning"
vglabel_system="hydralvm"

tmp_mnt="/tmp/mnt"
mkdir -p /tmp/mnt

# put lvm backups to /tmp so lvcreate does not fail due to ro-rootfs
mkdir -p /tmp/lvm
export LVM_SYSTEM_DIR="/tmp/lvm"

copy_verity_artifacts() {
    mnt="$1"
    label="$2"

    cp "${a_rootfs_hashdevice}" "${mnt}/verity/${label}.hashdevice"
    cp "${a_rootfs_roothash}" "${mnt}/verity/${label}.roothash"
    cp "${a_rootfs_roothash_signature}" "${mnt}/verity/${label}.roothash.signature"
}

# remove old fragments of provisioning LVs
lvremove -y --devices "${dev}p4" "${vglabel_system}"
vgremove -y --devices "${dev}p4" "${vglabel_system}"

# remove old fragments of provisioning LVs
vgchange -a n "${vglabel}"
lvremove -y "${vglabel}"
vgremove -y "${vglabel}"

pvremove "${dev}p4"

# Clean up any LVM remains
rm -rf -- "/dev/${vglabel}"
dmsetup ls --target linear 2>/dev/null | awk "\$1 ~ /^${vglabel}-/ {print \$1}" | xargs -r -n1 dmsetup remove
udevadm settle

parted --script "${dev}" \
    mklabel msdos \
    unit MiB \
    mkpart primary 12 140 \
    mkpart primary 140 268 \
    mkpart primary 268 396 \
    mkpart primary 396 100%

mkfs.ext4 -qF "${dev}p1"
mkfs.ext4 -qF "${dev}p2"
mkfs.ext4 -qF "${dev}p3"

# prepare bootloader
dd if="${a_uboot}" of="${dev}" bs=1024 seek=1
sync

# prepare provisioning fitimage
mount "${dev}p1" "${tmp_mnt}"
cp "${a_fitimage_provisioning}" "${tmp_mnt}/fitImage.signed"
cp "${a_fitimage}" "${tmp_mnt}/fitImage.signed.deploy"
umount "${tmp_mnt}"

# prepare LVM
pvcreate -ff -y "${dev}p4"
vgcreate -ff "${vglabel}" "${dev}p4"

rootfs_bytes=$(tail -c 4 "${a_rootfs_gz}" | od -An -tu4 | xargs)
# no need for alignment as verity images are always a multiple of 512 in size
lvcreate -y -n "rootfs_a" -L "${rootfs_bytes}B" "${vglabel}"
lvcreate -y -n "rootfs_b" -L "${rootfs_bytes}B" "${vglabel}"
lvcreate -y -n "userdata_a" -L 512MB "${vglabel}"
lvcreate -y -n "userdata_b" -L 512MB "${vglabel}"
lvcreate -y -n "keystore" -L 128MB "${vglabel}"
lvcreate -y -n "provisioning" -L 128MB "${vglabel}"
lvcreate -y -n "datastore" -L 128MB "${vglabel}"

lvcreate -y -n "pvsn_rootfs" -L "${rootfs_bytes}B" "${vglabel}"
lvcreate -y -n "pvsn_userdata" -L 512MB "${vglabel}"
lvcreate -y -n "pvsn_provisioning" -L 128MB "${vglabel}"
lvcreate -y -n "pvsn_datastore" -L 128MB "${vglabel}"

vgchange -a y
vgmknodes

# prepare keystore volume (skip rootfs_b artifacts)
keystore_dev="/dev/${vglabel}/keystore"

mkfs.ext4 -qF "${keystore_dev}"
mount "${keystore_dev}" "${tmp_mnt}"
mkdir "${tmp_mnt}/caam" "${tmp_mnt}/verity"
copy_verity_artifacts "${tmp_mnt}" "rootfs_a"
umount "${tmp_mnt}"

# write un-encrypted rootfs_a
zcat "${a_rootfs_gz}" > "/dev/${vglabel}/pvsn_rootfs"

# prepare ext4 volumes
mkfs.ext4 -qF "/dev/${vglabel}/pvsn_userdata"
mkfs.ext4 -qF "/dev/${vglabel}/pvsn_provisioning"
mkfs.ext4 -qF "/dev/${vglabel}/pvsn_datastore"

# Deactivate and rename volume group (see https://bugzilla.redhat.com/show_bug.cgi?id=2086765 on renaming)
vgchange --devices "${dev}p4" -an "${vglabel}"
vgcfgbackup --devices "${dev}p4" --file /tmp/hipos-lvm.txt "${vglabel}"
sed -iE "s/\(^\)${vglabel}\(\s*{\)/\1${vglabel_system}\2/" /tmp/hipos-lvm.txt
vgcfgrestore --devices "${dev}p4" --file /tmp/hipos-lvm.txt -y "${vglabel_system}"

sync
