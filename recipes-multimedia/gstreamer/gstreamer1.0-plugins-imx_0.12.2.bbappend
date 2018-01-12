FILESEXTRAPATHS_prepend := "${THISDIR}/gstreamer1.0-plugins-imx-0.12.2:"

SRC_URI_append = " \
	file://0001-imxg2dvideosink-allocation-cache-fix-HYP-13887.patch \
	file://0001-param-check-added-to-avoid-encoder-crash-on-flush-HYP-15795.patch \
	file://0002-adding-gstperf.patch \
	file://0003-perf-parameter-print-label.patch \
"
