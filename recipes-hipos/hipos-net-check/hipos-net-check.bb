DESCRIPTION = "This systemd-service is used to enforce consistency of network settings in board controller and in uboot."
SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS:${PN} = "python3"

PR = "r1"

SRC_URI = " file://hipos-net-check.service  \
            file://hipos-net-check.py \
	          file://COPYING "

FILES:${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-net-check.py \
		"

SYSTEMD_SERVICE:${PN} = "hipos-net-check.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-net-check.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-net-check.py ${D}${sysconfdir}/hipos/
}
