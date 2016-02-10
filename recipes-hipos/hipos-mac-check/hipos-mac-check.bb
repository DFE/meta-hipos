DESCRIPTION = "This systemd-service is used to enforce consistency of mac set in board controller and in uboot."
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS_${PN} = "python"

PR = "r1"

SRC_URI = " file://hipos-mac-check.service  \
            file://hipos-mac-check.py \
	          file://COPYING "

FILES_${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-mac-check.py \
		"

SYSTEMD_SERVICE_${PN} = "hipos-mac-check.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-mac-check.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-mac-check.py ${D}${sysconfdir}/hipos/
}
