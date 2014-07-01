DESCRIPTION = "This systemd-service is used to get serial number"
SECTION = "base"
LICENSE = "GPLv2"
PACKAGE_ARCH = "all"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd

RDEPENDS_${PN} = " libdrbcc "

PR = "r17"

SRC_URI = " file://hipos-device-info.service  \
            file://hipos-device-info.sh \
	    file://COPYING "

FILES_${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-device-info.sh \
		"

SYSTEMD_SERVICE_${PN} = "hipos-device-info.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-device-info.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-device-info.sh ${D}${sysconfdir}/hipos/
}

