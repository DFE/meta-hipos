
COMPATIBLE_MACHINE = "(himx0280)"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_himx0280 =  " \
	file://defconfig \
	file://0001-add-himx0280-board.patch \
"

do_configure_prepend_himx0280() {
	cp ${WORKDIR}/defconfig ${B}/arch/arm/configs/himx0280_defconfig
}
