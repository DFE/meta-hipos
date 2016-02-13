DESCRIPTION = "HIPOS RTP abstraction library"
SECTION = "console/utils"
PRIORITY = "optional"
DEPENDS = "glib-2.0 gstreamer1.0 gstreamer1.0-plugins-base"
LICENSE = "GPLv3 & LGPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504 \
		    file://COPYING.LIB;md5=e6a600fd5e1d9cbde2d983680233ad02 "

PR = "r4"

PE = "1"
SRCREV="${AUTOREV}"
PV = "gitr${SRCPV}"

SRC_URI = "git://bitbucket.org/dresearchfe/${BPN}.git;protocol=https"

S = "${WORKDIR}/git"

PACKAGES += " ${PN}-tst ${PN}-demo "

FILES_${PN} = "${libdir}/*.so.*"
FILES_${PN}-tst = "${bindir}/drtp_test"
FILES_${PN}-demo = "${bindir}/drtp-gst-demo"

EXTRA_OECONF = ""

inherit autotools pkgconfig

BBCLASSEXTEND = "native"
