DESCRIPTION = "This systemd-service is used to turn power on of lte and gps"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS_${PN} = " bash gpsd "

PR = "r13"

SRC_URI = " \
        file://hipos-lte-gps.service \
	file://modem-at.service \
        file://hipos-lte-gps.sh \
	file://99-modem.rules \
        file://99-gps.rules \
        file://hipos-gps-on.sh \
	    file://COPYING "

FILES_${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-lte-gps.sh \
               ${sysconfdir}/hipos/hipos-gps-on.sh \
	       ${sysconfdir}/udev/rules.d/99-modem.rules \
	       ${sysconfdir}/udev/rules.d/99-gps.rules "

SYSTEMD_SERVICE_${PN} = "hipos-lte-gps.service modem-at.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-lte-gps.service ${D}${base_libdir}/systemd/system/
  install -m 0644 ${WORKDIR}/modem-at.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-lte-gps.sh ${D}${sysconfdir}/hipos/
  install -m 0755 ${WORKDIR}/hipos-gps-on.sh ${D}${sysconfdir}/hipos/
  install -d ${D}${sysconfdir}/udev/rules.d
  install -m 0644 ${WORKDIR}/99-modem.rules ${D}${sysconfdir}/udev/rules.d/99-modem.rules
  install -m 0644 ${WORKDIR}/99-gps.rules ${D}${sysconfdir}/udev/rules.d/99-gps.rules
}
