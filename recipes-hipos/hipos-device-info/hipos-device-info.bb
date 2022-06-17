DESCRIPTION = "This systemd-service is used to get serial number"
SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS:${PN} = "libdrbcc bash hip-machinfo hip-board"

PR = "r23"

SRC_URI = " file://hipos-device-info.service  \
            file://hipos-device-info.sh \
	    file://COPYING "

FILES:${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-device-info.sh \
		"

SYSTEMD_SERVICE:${PN} = "hipos-device-info.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-device-info.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-device-info.sh ${D}${sysconfdir}/hipos/
}

