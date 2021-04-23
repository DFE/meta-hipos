DESCRIPTION = "HIPOS Boardcontroller communication tool"
SECTION = "libs"
DEPENDS = "readline lockdev"
RDEPENDS_${PN} = "hip-udev-extra-rules"
RDEPENDS_drbcc = "hip-udev-extra-rules"

LICENSE = "GPLv3 & LGPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504 \
		    file://COPYING.LIB;md5=e6a600fd5e1d9cbde2d983680233ad02 "

PR = "r7"

S = "${WORKDIR}/git"

# do not rename this variable because it will be processed by some
# external tooling (see https://dresearchfe.jira.com/browse/HYP-14343)
DRSRCBRANCH="6.2"

SRC_URI = "git://github.com/DFE/libdrbcc.git;branch=${DRSRCBRANCH}"
SRCREV_default_pn-libdrbcc = "9f14c1a33ad8b41bcd3cacbbb376f19ada7a0189"

PACKAGES += " drbcc "

FILES_${PN} = "${libdir}/*.so.*"
FILES_drbcc = "${bindir}/*"

inherit autotools


