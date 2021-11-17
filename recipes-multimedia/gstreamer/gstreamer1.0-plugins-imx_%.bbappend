OVRDEPENDS += " virtual/libg2d "
# DEPENDS is in yocto pyro necessary
DEPENDS += " virtual/libg2d "

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-phys_mem_allocator-refcountig-mmap-fix-HYP-12917.patch \
	file://0001-imxvpudec-new-property-reordering-enabled-added.patch \
	file://0001-new-property-framerate-numerator-added-to-decoder-ba.patch \
	file://0001-cropping-added-to-video-sink-plugins-HYP-15795.patch \
	file://0002-adding-gstperf.patch \
	file://0003-perf-parameter-print-label.patch \
"

# This is a workaround until waf is fixed in oe-core
EXTRA_OECONF:append = " --libdir=${libdir}"

