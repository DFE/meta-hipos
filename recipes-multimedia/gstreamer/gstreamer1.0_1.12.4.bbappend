
FILESEXTRAPATHS_prepend := "${THISDIR}/gstreamer1.0-1.12.4:"

SRC_URI_append = " \
	file://avg_bitrate-calculation-critical-warning-fix.patch \
"
