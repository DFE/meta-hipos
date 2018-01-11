FILESEXTRAPATHS_prepend := "${THISDIR}/gstreamer1.0-plugins-imx-0.12.2:"

SRC_URI_append = " \
	file://0002-adding-gstperf.patch \
	file://0003-perf-parameter-print-label.patch \
"
