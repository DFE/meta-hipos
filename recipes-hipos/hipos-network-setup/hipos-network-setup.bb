DESCRIPTION = "This systemd-service is used to setup network phys"
SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS:${PN} = " ethtool bash hip-machinfo "

PR = "r26"

SRC_URI = " file://hipos-network-setup.service  \
            file://hipos-network-setup.sh \
	    file://COPYING "

FILES:${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-network-setup.sh \
		"

SYSTEMD_SERVICE:${PN} = "hipos-network-setup.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-network-setup.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-network-setup.sh ${D}${sysconfdir}/hipos/
}

