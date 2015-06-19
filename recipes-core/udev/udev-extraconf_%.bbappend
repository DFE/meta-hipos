RDEPENDS_${PN} += " stat "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
	       file://0001-Hipos-do-not-init-wlan-via-udev-HYP-11339.patch \
"


