FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG_remove = "networkd resolved"

SRC_URI_append = " \
	       file://0001-systemd-halt.service-always-poweroff-on-halt.patch \
	       file://0001-systemd-reboot.service-always-poweroff-on-reboot.patch \
               file://0001-systemd-automatically-start-networking.service-HYP-1.patch \
               file://0001-udev-wait-for-ldconfig.service-and-opkg-configure.se.patch \
"

SRC_URI_append_nitrogen6x = " \
               file://0001-systemd-add-watchdog.patch \
"
