
FILESEXTRAPATHS_prepend := "${THISDIR}/linux-imx-4.9.123:"

SRC_URI_append_himx0438 = " \
        file://fsl-imx8mm-himx0438-ipcam.dts \
"

do_configure_prepend_himx0438() {
	cp ${WORKDIR}/fsl-imx8mm-himx0438-ipcam.dts ${S}/arch/arm64/boot/dts/freescale/
}
