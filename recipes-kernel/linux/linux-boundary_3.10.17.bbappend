
COMPATIBLE_MACHINE = "(himx0280|himx|nitrogen6x|nitrogen6x-lite|mx6)"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_himx0280 =  " \
	file://defconfig \
	file://0001-add-himx0280-board.patch \
"

do_configure_prepend_himx0280() {
	cp ${WORKDIR}/defconfig ${B}/arch/arm/configs/himx0280_defconfig
}

do_configure_prepend_nitrogen6x() {
        cp ${WORKDIR}/defconfig ${B}/arch/arm/configs/nitrogen6x_defconfig
}

