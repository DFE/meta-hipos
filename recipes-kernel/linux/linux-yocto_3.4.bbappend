# Use latest yocto kernel

COMPATIBLE_MACHINE = "hidav-kirkwood"

DEPENDS += " lzop-native test-harness-native "
RDEPENDS_${PN} += " mtd-utils gawk busybox bootconfig "

MACHINE_KERNEL_PR = "r14"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI +=  " file://defconfig \
	      file://xor-min-byte-count.patch \
              file://spi-enable.patch \
	      file://PLX-Tech-3380-driver.patch \
	    "

