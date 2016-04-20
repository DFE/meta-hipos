DESCRIPTION = "This systemd-service is used to check usb connections"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS_${PN} = " bash "

PR = "r1"

SRC_URI = " file://hipos-usb-check.service  \
            file://hipos-usb-check.sh \
	    file://COPYING "

FILES_${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-usb-check.sh \
		"

SYSTEMD_SERVICE_${PN} = "hipos-usb-check.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-usb-check.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-usb-check.sh ${D}${sysconfdir}/hipos/
}

