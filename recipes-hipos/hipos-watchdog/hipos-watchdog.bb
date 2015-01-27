DESCRIPTION = "This systemd-service is used to implement the watchdog using drbcc"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS_${PN} = " drbcc "

PR = "r12"

SRC_URI = " \
        file://hipos-watchdog.service \
        file://hipos-watchdog.timer \
	    file://COPYING "

FILES_${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/systemd "

SYSTEMD_SERVICE_${PN} = "hipos-watchdog.service hipos-watchdog.timer"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-watchdog.service ${D}${base_libdir}/systemd/system/
  install -m 0644 ${WORKDIR}/hipos-watchdog.timer ${D}${base_libdir}/systemd/system/
}