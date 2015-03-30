DESCRIPTION = "This systemd-service is used to setup network phys"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS_${PN} = " ethtool bash "

PR = "r17"

SRC_URI = " file://hipos-network-setup.service  \
            file://hipos-network-setup.sh \
	    file://COPYING "

FILES_${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-network-setup.sh \
		"

SYSTEMD_SERVICE_${PN} = "hipos-network-setup.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-network-setup.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-network-setup.sh ${D}${sysconfdir}/hipos/
}

