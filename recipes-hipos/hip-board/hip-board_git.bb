DESCRIPTION = "Obtain HydraIP board util"
PRIORITY = "optional"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "
RDEPENDS:${PN} = "bash hip-machinfo mtd-utils"

PR = "r1"

SRC_URI = " file://hip-board \
	    file://COPYING \
"

inherit allarch

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${WORKDIR}/hip-board ${D}${sbindir}/hip-board
}
