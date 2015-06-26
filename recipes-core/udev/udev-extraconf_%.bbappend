RDEPENDS_${PN} += " stat "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
	       file://0001-Hipos-fix-hotplug-on-boot-HYP-11803.patch \
"


