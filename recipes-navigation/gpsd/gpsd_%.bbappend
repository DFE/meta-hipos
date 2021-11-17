FILESEXTRAPATHS:prepend := "${THISDIR}/gpsd:"

SRC_URI:append = " \
	file://Clear-DOPs-again.patch \
"

# enable DBus Export
EXTRA_OECONF = " dbus_export='true' "

SYSTEMD_SERVICE:${PN} = "${PN}.service"
