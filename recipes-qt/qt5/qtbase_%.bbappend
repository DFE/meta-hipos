# Append qtbase configuration

PACKAGECONFIG_append_mx6 = " tslib icu examples sql-sqlite "

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://0009-digest-auth-fix.patch \
"

