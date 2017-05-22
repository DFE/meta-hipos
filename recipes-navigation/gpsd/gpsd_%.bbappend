FILESEXTRAPATHS_prepend := "${THISDIR}/gpsd:"

SRC_URI_append = " \
	file://Clear-DOPs-again.patch \
"

# enable DBus Export
EXTRA_OECONF = " dbus_export='true' "

# override PACKAGECONFIG without 'qt' because 'qt4-x11-free' dependency
# cannot be fullfilled because 'x11' not in DISTRO_FEATURES
PACKAGECONFIG ??= "${@bb.utils.contains('DISTRO_FEATURES', 'bluetooth', 'bluez', '', d)}"
PACKAGECONFIG[bluez] = "bluez='true',bluez='false',${BLUEZ}"

SYSTEMD_SERVICE_${PN} = "${PN}.service"
