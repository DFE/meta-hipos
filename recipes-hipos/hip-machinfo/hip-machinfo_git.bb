DESCRIPTION = "Obtain HydraIP machine/submachine type"
PRIORITY = "optional"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "
RDEPENDS:${PN} = "bash"

PR = "r1"

SRC_URI = " file://hip-machinfo  \
	    file://COPYING \
"

inherit allarch

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${WORKDIR}/hip-machinfo ${D}${sbindir}/hip-machinfo
}
