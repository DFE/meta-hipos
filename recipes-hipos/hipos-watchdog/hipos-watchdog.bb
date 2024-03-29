DESCRIPTION = "This systemd-service is used to implement the watchdog using drbcc"
SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS:${PN} = " drbcc bash "

PR = "r14"

SRC_URI = " \
        file://hipos-watchdog.service \
        file://hipos-watchdog.timer \
        file://hipos-watchdog.sh \
	    file://COPYING "

FILES:${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-watchdog.sh \
               ${sysconfdir}/systemd "

SYSTEMD_SERVICE:${PN} = "hipos-watchdog.service hipos-watchdog.timer"

do_install () {
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-watchdog.sh ${D}${sysconfdir}/hipos/
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-watchdog.service ${D}${base_libdir}/systemd/system/
  install -m 0644 ${WORKDIR}/hipos-watchdog.timer ${D}${base_libdir}/systemd/system/
}
