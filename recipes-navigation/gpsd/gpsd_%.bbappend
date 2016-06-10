# enable DBus Export
EXTRA_OECONF = " dbus_export='true' "

# override PACKAGECONFIG without 'qt' because 'qt4-x11-free' dependency
# cannot be fullfilled because 'x11' not in DISTRO_FEATURES
PACKAGECONFIG ??= "${@base_contains('DISTRO_FEATURES', 'bluetooth', 'bluez', '', d)}"
PACKAGECONFIG[bluez] = "bluez='true',bluez='false',${BLUEZ}"
