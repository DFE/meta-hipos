inherit kernel_wireless_regdb

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-imx-6.6:"

# unset KBUILD_DEFCONFIG. To avoid that the defconfig must be located in kernel
# source tree.
KBUILD_DEFCONFIG:mx8-generic-bsp = ""

SRC_URI:append:himx8 = " \
	file://defconfig \
	file://imx8mp-himx8-repro.dts \
	file://0001-usb-misc-onboard_usb_hub-add-USB5744-support.patch \
	file://0001-st7735r-Add-rspro-TFT-module-HYP-33833.patch \
"

do_configure:prepend:himx8() {
        cp ${WORKDIR}/defconfig ${S}/arch/arm64/configs/himx8_defconfig
	cp ${WORKDIR}/imx8mp-himx8-repro.dts ${S}/arch/arm64/boot/dts/freescale/
}

