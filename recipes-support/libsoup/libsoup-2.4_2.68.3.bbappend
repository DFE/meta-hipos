
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

SRC_URI_append = " \
	file://0001-WebSockets-do-not-start-the-input-source-when-IO-is-.patch \
"
