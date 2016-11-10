OVRDEPENDS += " virtual/libg2d "

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://0001-phys_mem_allocator-refcountig-mmap-fix-HYP-12917.patch \
	file://0001-imxg2dvideosink-allocation-cache-fix-HYP-13887.patch \
	file://0001-imxvpudec-new-property-reordering-enabled-added.patch \
	file://0001-new-property-framerate-numerator-added-to-decoder-ba.patch \
"
