DESCRIPTION = "This systemd-service is used to turn power on of lte and gps"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS_${PN} = " bash "

PR = "r12"

SRC_URI = " \
        file://hipos-lte-gps.service \
        file://hipos-lte-gps.sh \
	    file://COPYING "

FILES_${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-lte-gps.sh "

SYSTEMD_SERVICE_${PN} = "hipos-lte-gps.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-lte-gps.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-lte-gps.sh ${D}${sysconfdir}/hipos/
}
