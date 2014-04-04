DESCRIPTION = "This systemd-service is used to implement the watchdog using drbcc"
SECTION = "base"
LICENSE = "GPLv2"
PACKAGE_ARCH = "all"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd

RDEPENDS_${PN} = " libdrbcc "

PR = "r8"

SRC_URI = " \
        file://hipos-watchdog.service \
	    file://COPYING "

FILES_${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/systemd "

SYSTEMD_SERVICE_${PN} = "hipos-watchdog.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-watchdog.service ${D}${base_libdir}/systemd/system/
}
