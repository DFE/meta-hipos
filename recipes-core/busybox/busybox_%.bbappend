# look for files in the layer first
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://0001-Disable-unsafe-symlink-check-HYP-19186.patch \
"

