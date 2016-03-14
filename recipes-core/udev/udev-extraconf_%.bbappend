RDEPENDS_${PN} += " stat "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
	       file://0001-Hipos-use-allow-hotplug-HYP-13876.patch \
"


