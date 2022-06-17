DESCRIPTION = "This systemd-service is used to setup network phys"
SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS:${PN} = " ethtool bash "

PR = "r5"

SRC_URI = " file://hipos-system-tuning.service  \
            file://hipos-system-tuning.sh \
	    file://COPYING "

FILES:${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-system-tuning.sh \
		"

SYSTEMD_SERVICE:${PN} = "hipos-system-tuning.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-system-tuning.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-system-tuning.sh ${D}${sysconfdir}/hipos/
}

