OVRDEPENDS += " virtual/libg2d "

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://0001-phys_mem_allocator-refcountig-mmap-fix-HYP-12917.patch \
	file://0001-imxvpudec-new-property-reordering-enabled-added.patch \
	file://0001-new-property-framerate-numerator-added-to-decoder-ba.patch \
	file://0001-cropping-added-to-video-sink-plugins-HYP-15795.patch \
"
