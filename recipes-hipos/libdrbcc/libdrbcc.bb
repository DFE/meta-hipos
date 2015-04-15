DESCRIPTION = "HIPOS Boardcontroller communication tool"
SECTION = "libs"
DEPENDS = "readline lockdev"
RDEPENDS_${PN} = "hip-udev-extra-rules"
RDEPENDS_drbcc = "hip-udev-extra-rules"

LICENSE = "GPLv3 LGPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504 \
		    file://COPYING.LIB;md5=e6a600fd5e1d9cbde2d983680233ad02 "

PR = "r6"

S = "${WORKDIR}/git"

SRC_URI = "git://github.com/DFE/libdrbcc.git"
SRCREV_default_pn-libdrbcc = "e75d557a43658f95d672b2fe2101041e6df269eb"

PACKAGES += " drbcc "

FILES_${PN} = "${libdir}/*.so.*"
FILES_drbcc = "${bindir}/*"

inherit autotools


