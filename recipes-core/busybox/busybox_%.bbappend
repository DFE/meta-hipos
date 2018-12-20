# look for files in the layer first
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://0001-Disable-unsafe-symlink-check-HYP-19186.patch \
"
pkg_postinst_${PN}_append () {
# update-alternatives has an error code if e.g. no symlink is found.
# update-alternatives: Error: not linking /sbin/mke2fs to /bin/busybox.nosuid since /sbin/mke2fs exists and is not a link
# This means that all subsequent update-alternative calls are not executed.
# As long as not all packages use the update-alternative correctly, the feature will be disabled.
# Disable: Exit immediately if a command exits with a non-zero status. 
set +e
}
