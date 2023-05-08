FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG:remove = "networkd"

# Enable kmod package configuration
# A recipe append from meta-angstrom removes kmod configuration.
# The builtin kmod is mandatory. Otherwise kernel modules are not
# loaded and it comes to error message:
# Invalid rule /lib/udev/rules.d/80-drivers.rules:5: RUN{builtin}: 'kmod load $env{MODALIAS}' unknown
PACKAGECONFIG:append = " kmod "

SRC_URI:append = " \
               file://0001-systemd-automatically-start-networking.service-HYP-1.patch \
               file://0001-udev-wait-for-ldconfig.service-and-opkg-configure.se.patch \
               file://systemd-udev-service-remove-MountFlags.patch \
"

SRC_URI:append:himx0294 = " \
	       file://0001-systemd-halt.service-always-poweroff-on-halt.patch \
	       file://0001-systemd-reboot.service-always-poweroff-on-reboot.patch \
"

SRC_URI:append:hinat = " \
	       file://0001-systemd-halt.service-always-poweroff-on-halt.patch \
	       file://0001-systemd-reboot.service-always-poweroff-on-reboot.patch \
"
SRC_URI:append:himx0438 = " \
	       file://0001-systemd-halt.service-always-reboot-on-halt.patch \
"

do_install:append () {
	# Disable Predictable Network Interface Names
	# https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
	install -d ${D}/etc/systemd/network/
	ln -s /dev/null ${D}/etc/systemd/network/99-default.link
}
