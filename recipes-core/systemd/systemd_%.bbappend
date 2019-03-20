FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG_remove = "networkd resolved"

# Enable kmod package configuration
# A recipe append from meta-angstrom removes kmod configuration.
# The builtin kmod is mandatory. Otherwise kernel modules are not
# loaded and it comes to error message:
# Invalid rule /lib/udev/rules.d/80-drivers.rules:5: RUN{builtin}: 'kmod load $env{MODALIAS}' unknown
PACKAGECONFIG_append = " kmod "

SRC_URI_append = " \
	       file://0001-systemd-halt.service-always-poweroff-on-halt.patch \
	       file://0001-systemd-reboot.service-always-poweroff-on-reboot.patch \
               file://0001-systemd-automatically-start-networking.service-HYP-1.patch \
               file://0001-udev-wait-for-ldconfig.service-and-opkg-configure.se.patch \
               file://systemd-udev-service-remove-MountFlags.patch \
"

