# look for files in the layer first
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://0001-filter-denied-virtual-interfaces-when-adding-address.patch "
