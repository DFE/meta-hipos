FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG_remove = "networkd resolved"

# The package 'lz4' is not allways installed in rocko-branch. Then the following
# error occurs during booting:
# /sbin/init: error while loading shared libraries: liblz4.so.1: cannot open shared object file: No such file or directory
# Kernel panic - not syncing: Attempted to kill init! exitcode=0x00007f00
# To avoid this error the 'lz4' package will be installed explicitly.
RDEPENDS_${PN} += " lz4 "

SRC_URI_append = " \
	       file://0001-systemd-halt.service-always-poweroff-on-halt.patch \
	       file://0001-systemd-reboot.service-always-poweroff-on-reboot.patch \
               file://0001-systemd-automatically-start-networking.service-HYP-1.patch \
               file://0001-udev-wait-for-ldconfig.service-and-opkg-configure.se.patch \
               file://systemd-udev-service-remove-MountFlags.patch \
"

SRC_URI_append_nitrogen6x = " \
               file://0001-systemd-add-watchdog.patch \
"
