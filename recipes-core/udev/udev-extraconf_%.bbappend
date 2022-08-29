RDEPENDS:${PN} += " coreutils "

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
	       file://0001-Hipos-use-allow-hotplug-HYP-13876.patch \
		   file://0001-mount.sh-remount-ro-before-unmounting-HYP-29031.patch \
"


