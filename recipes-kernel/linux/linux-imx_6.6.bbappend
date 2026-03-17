inherit kernel_wireless_regdb

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-imx-6.6:"

# unset KBUILD_DEFCONFIG. To avoid that the defconfig must be located in kernel
# source tree.
KBUILD_DEFCONFIG = ""

SRC_URI:append:himx8 = " \
	file://imx8mp-himx8-repro.dts \
"

do_configure:prepend:himx8() {
        cp ${WORKDIR}/defconfig ${S}/arch/arm64/configs/himx8_defconfig
	cp ${WORKDIR}/imx8mp-himx8-repro.dts ${S}/arch/arm64/boot/dts/freescale/
}

