DESCRIPTION = "This systemd-service is used to setup network phys"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS_${PN} = " bash "

PR = "r1"

SRC_URI = " file://hipos-vmstat.service  \
            file://hipos-vmstat.sh \
	    file://COPYING "

FILES_${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/hipos/hipos-vmstat.sh \
		"

SYSTEMD_SERVICE_${PN} = "hipos-vmstat.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-vmstat.service ${D}${base_libdir}/systemd/system/
  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/hipos-vmstat.sh ${D}${sysconfdir}/hipos/
}

