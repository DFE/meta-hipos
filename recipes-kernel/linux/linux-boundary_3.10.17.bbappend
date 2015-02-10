
COMPATIBLE_MACHINE = "(himx0294|himx0280|himx|nitrogen6x|nitrogen6x-lite|mx6)"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_himx0280 =  " \
	file://defconfig \
	file://imx6qdl-himx0280.dtsi \
	file://imx6q-himx0280.dts \
	file://0001-add-himx0280-board.patch \
"

SRC_URI_append_himx0294 =  " \
	file://imx6qdl-himx0294.dtsi \
	file://imx6q-himx0294.dts \
"

do_configure_prepend_himx0280() {
	cp ${WORKDIR}/defconfig ${B}/arch/arm/configs/himx0280_defconfig
	cp ${WORKDIR}/imx6qdl-himx0280.dtsi ${B}/arch/arm/boot/dts/imx6qdl-himx0280.dtsi
	cp ${WORKDIR}/imx6q-himx0280.dts ${B}/arch/arm/boot/dts/imx6q-himx0280.dts
}

do_configure_prepend_himx0294() {
        cp ${WORKDIR}/defconfig ${B}/arch/arm/configs/himx0294_defconfig
	cp ${WORKDIR}/imx6qdl-himx0294.dtsi ${B}/arch/arm/boot/dts/imx6qdl-himx0294.dtsi
	cp ${WORKDIR}/imx6q-himx0294.dts ${B}/arch/arm/boot/dts/imx6q-himx0294.dts
}

do_configure_prepend_nitrogen6x() {
        cp ${WORKDIR}/defconfig ${B}/arch/arm/configs/nitrogen6x_defconfig
}

