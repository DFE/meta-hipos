
FILESEXTRAPATHS_prepend := "${THISDIR}/linux-imx-4.14.98:"

SRC_URI_append_himx0438 = " \
        file://fsl-imx8mm-himx0438-ipcam.dts \
        file://0001-Enable-PLL-with-400MHz-HYP-22201.patch \
"

do_configure_prepend_himx0438() {
	cp ${WORKDIR}/fsl-imx8mm-himx0438-ipcam.dts ${S}/arch/arm64/boot/dts/freescale/
}
