FILESEXTRAPATHS_prepend := "${THISDIR}/gpsd:"

SRC_URI_append = " \
	file://Clear-DOPs-again.patch \
	file://0001-gpsd-dbusexport.c-Fix-broken-d-bus-message-time.patch \
"

# enable DBus Export
EXTRA_OECONF = " dbus_export='true' "

SYSTEMD_SERVICE_${PN} = "${PN}.service"
