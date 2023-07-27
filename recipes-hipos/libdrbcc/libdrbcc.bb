DESCRIPTION = "HIPOS Boardcontroller communication tool"
SECTION = "libs"
DEPENDS = "libedit lockdev"
RDEPENDS:${PN} = "hip-udev-extra-rules"
RDEPENDS:drbcc = "hip-udev-extra-rules"

LICENSE = "GPL-3.0-only & LGPL-3.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504 \
		    file://COPYING.LIB;md5=e6a600fd5e1d9cbde2d983680233ad02 "

PR = "r7"

S = "${WORKDIR}/git"

# do not rename this variable because it will be processed by some
# external tooling (see https://dresearchfe.jira.com/browse/HYP-14343)
DRSRCBRANCH="6.9"

SRC_URI = "git://github.com/DFE/libdrbcc.git;branch=${DRSRCBRANCH};protocol=https"
SRCREV = "55505ffb87aca4eee65bb6fb28247362de584aae"

PACKAGES += " drbcc "

FILES:${PN} = "${libdir}/*.so.*"
FILES:drbcc = "${bindir}/*"

inherit autotools pkgconfig


