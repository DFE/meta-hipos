#!/bin/bash

export LANG=c

function print_usage {
    echo -e "\nUsage: $0 <block device> <image>"
    echo "Generate bootable USB stick using <image> on <block device>."
    echo -e "Valid images: hipos-devimage, hipos-prodimage\n"
}

if [ ! -b "$1" ] ; then
    echo -e "\nError: invalid device"
    print_usage    
    exit
fi

if [[ $2 != "hipos-devimage" && $2 != "hipos-prodimage" ]] ; then
    echo -e "\nError: invalid image"
    print_usage
    exit
fi

if ! whoami | grep -wq "root"; then
    echo -e "\nYou must be ROOT in order for this script to work.\nWait, I can fix this. I'll run  \"sudo $0 $@\" for you.\n"
    sudo $0 $@
    exit
fi

echo -en "\nTHIS WILL ERASE ALL DATA ON $1. ARE YOU SURE? (y/N):"
read yn

case $yn in
    Y)  ;;
    y)  ;;
    *)  echo "Aborted."; exit
esac

DRIVE=$1

umount ${DRIVE}1
umount ${DRIVE}2

set -e

dd if=/dev/zero of=$DRIVE bs=1024 count=1024

SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`

echo DISK SIZE - $SIZE bytes

CYLINDERS=`echo $SIZE/255/63/512 | bc`

echo -e "----\nCreating Partitions\n--"

fdisk -c=dos -H 255 -S 63 -C $CYLINDERS $DRIVE << EOF
o
n
p

20480
2097152
n
p

2097153

w
EOF

echo -e "----\nFormatting EXT4 (rootfs1) Partition\n--"
mkfs.ext4 -L "rootfs1" ${DRIVE}1

echo -e "----\nFormatting EXT4 (rootfs2) Partition\n--"
mkfs.ext4 -L "rootfs2" ${DRIVE}2

echo -e "----\nCopying rootfs-files (rootfs2)\n--"
mkdir -p tmp_mnt
mount ${1}2 tmp_mnt
pushd tmp_mnt > /dev/null
tar xjf ../$2-*.tar.bz2
popd > /dev/null
umount tmp_mnt
rm -rf tmp_mnt

echo -e "----\nCopying rootfs-files (rootfs1)\n--"
mkdir -p tmp_mnt
mount ${1}1 tmp_mnt
pushd tmp_mnt > /dev/null
tar xjf ../$2-*.tar.bz2
popd > /dev/null
umount tmp_mnt || umount -l tmp_mnt
echo -e "----\nCopying bootloader\n--"
dd if=u-boot.imx of=${DRIVE} seek=2 bs=512
rm -rf tmp_mnt
echo -e "----\nFlushing changes to device\n--"
sync
blockdev --flushbufs "${DRIVE}"

echo -e "----\nDONE."
