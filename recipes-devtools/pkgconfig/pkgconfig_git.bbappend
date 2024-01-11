# No architecture check for class-native
#
# ERROR: format not a string literal, format string not checked [-Werror=format-nonliteral]
#
# Origin: https://github.com/GNOME/glib/commit/8cdbc7fb2c8c876902e457abe46ee18a0b134486

FILESEXTRAPATHS_prepend_class-native := "${THISDIR}/files:"

SRC_URI_append_class-native = " \
        file://0001-Fix-compile-error-in-gdate.c-on-newer-OS.patch \
"
