
FILESEXTRAPATHS:prepend := "${THISDIR}/linux-imx-5.15:"

SRC_URI:append:himx8 = " \
        file://imx8mp-tqma8mpql-mba8mpxl.dts \
        file://imx8mp-tqma8mpql.dtsi \
        file://mba8mpxl.dtsi \
        file://imx8mp-tqma8mpql-mba8mpxl-hdmi.dts \
        file://imx8mp-tqma8mpql-mba8mpxl-hdmi-imx327.dts \
        file://imx8mp-mba8mpxl-imx327.dtsi \
        file://imx8mp-tqma8mpql-mba8mpxl-lvds-g101evn010.dts \
	file://0001-adv7180-Add-link_setup-function-HYP-27448.patch \
	file://0001-adv7180-Reset-on-set-power-HYP-27448.patch \
	file://0001-imx8-isi-cap-Fix-interaction-with-adv7280-m-HYP-2744.patch \
"

do_configure:prepend:himx8() {
	cp ${WORKDIR}/imx8mp-tqma8mpql-mba8mpxl.dts ${S}/arch/arm64/boot/dts/freescale/
	cp ${WORKDIR}/imx8mp-tqma8mpql.dtsi ${S}/arch/arm64/boot/dts/freescale/
	cp ${WORKDIR}/mba8mpxl.dtsi ${S}/arch/arm64/boot/dts/freescale/
	cp ${WORKDIR}/imx8mp-tqma8mpql-mba8mpxl-hdmi.dts ${S}/arch/arm64/boot/dts/freescale/
	cp ${WORKDIR}/imx8mp-tqma8mpql-mba8mpxl-hdmi-imx327.dts ${S}/arch/arm64/boot/dts/freescale/
	cp ${WORKDIR}/imx8mp-mba8mpxl-imx327.dtsi ${S}/arch/arm64/boot/dts/freescale/
	cp ${WORKDIR}/imx8mp-tqma8mpql-mba8mpxl-lvds-g101evn010.dts ${S}/arch/arm64/boot/dts/freescale/
}

SRC_URI:append:himx0438 = " \
        file://fsl-imx8mm-himx0438-ipcam.dts \
        file://0001-Enable-PLL-with-400MHz-HYP-22201.patch \
        file://0001-Set-ov5640-frame-rate-to-25-HYP-22201.patch \
"

do_configure:prepend:himx0438() {
	cp ${WORKDIR}/fsl-imx8mm-himx0438-ipcam.dts ${S}/arch/arm64/boot/dts/freescale/
}
