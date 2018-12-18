FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

PACKAGECONFIG_remove = "networkd resolved"

SRC_URI_append = " \
	       file://0001-systemd-halt.service-always-poweroff-on-halt.patch \
	       file://0001-systemd-reboot.service-always-poweroff-on-reboot.patch \
               file://0001-systemd-automatically-start-networking.service-HYP-1.patch \
               file://0001-udev-wait-for-ldconfig.service-and-opkg-configure.se.patch \
               file://systemd-udev-service-remove-MountFlags.patch \
               file://himx0294.conf \
"

do_install_append() {
	install -d ${D}${sysconfdir}/system.conf.d
	install -m 0644 ${WORKDIR}/himx0294.conf ${D}${sysconfdir}/system.conf.d/
}
