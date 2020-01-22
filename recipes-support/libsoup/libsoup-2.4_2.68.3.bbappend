
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI_append = " \
	file://0001-meson-dependency-HYP-22586.patch \
	file://0001-WebSockets-do-not-start-the-input-source-when-IO-is-.patch \
"
