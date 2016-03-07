FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
	file://0001-tw6869-phys-memory-address-patch-HACK.patch \
	file://0001-phys_mem_allocator-refcountig-mmap-fix-HYP-12917.patch \
	file://0001-me-search-range-property-added-for-encoders.patch \
"
