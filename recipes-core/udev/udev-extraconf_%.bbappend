RDEPENDS_${PN} += " stat "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
	       file://0003-Hipos-use-hotplug-if-configured-in-etc-network-inter.patch \
"


