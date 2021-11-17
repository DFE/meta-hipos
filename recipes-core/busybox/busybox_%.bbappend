FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	       file://0001-trace-error-but-don-t-die-HYP-20553.patch \
"

pkg_postinst:${PN}:append () {
# update-alternatives has an error code if e.g. no symlink is found.
# update-alternatives: Error: not linking /sbin/mke2fs to /bin/busybox.nosuid since /sbin/mke2fs exists and is not a link
# This means that all subsequent update-alternative calls are not executed.
# As long as not all packages use the update-alternative correctly, the feature will be disabled.
# Disable: Exit immediately if a command exits with a non-zero status. 
set +e
}
