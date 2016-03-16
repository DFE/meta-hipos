DESCRIPTION = "Additional HIPOS specific udev rules"
SECTION = "console/utils"
PRIORITY = "optional"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

PR = "r1"

SRC_URI = " \
	file://COPYING \
	file://30-ibis.rules \
	file://30-bcc.rules \
	file://30-fasy.rules \
"

S = "${WORKDIR}"

do_configure() {
	:
}

do_compile() {
	:
}

do_install() {
        install -d ${D}${sysconfdir}/udev/rules.d
        install -m 0644 ${S}/30-ibis.rules ${D}${sysconfdir}/udev/rules.d/30-ibis.rules
        install -m 0644 ${S}/30-bcc.rules ${D}${sysconfdir}/udev/rules.d/30-bcc.rules
        install -m 0644 ${S}/30-fasy.rules ${D}${sysconfdir}/udev/rules.d/30-fasy.rules
}
