
COMPATIBLE_MACHINE = "(himx0294|himx|nitrogen6x|nitrogen6x-lite|mx6)"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-boundary-3.14.28:"

# use HEAD revision of special tw6869 driver
SRCREV_FORMAT = "tw6869"
SRCREV_tw6869 = "${AUTOREV}"
PV_append = "+tw6869gitr${SRCPV}"

# do not rename this variable because it will be processed by some
# external tooling (see https://dresearchfe.jira.com/browse/HYP-14343)
DRSRCBRANCH="master"

SRC_URI_append = " \
	git://github.com/DFE/tw6869.git;protocol=https;destsuffix=git.tw6869;name=tw6869;branch=${DRSRCBRANCH} \
	file://0001-add-tw6869-to-parent-Kconfig-and-Makefile-HYP-11342.patch \
	file://0001-HYP-12986-run-tasklet-function-of-UART-DMA-within-IS.patch \
	file://mmc-sdhci-recompute-timeout_clk-when-needed.patch \
	file://mmc-sd-show-ssr-in-sysfs.patch \
"

SRC_URI_append_himx0294 = " \
	file://imx6qdl-himx0294-imoc.dtsi \
	file://imx6q-himx0294-imoc.dts \
	file://imx6qdl-himx0294-ivap.dtsi \
	file://imx6q-himx0294-ivap.dts \
        file://imx6qdl-himx0294-dvmon.dtsi \
        file://imx6q-himx0294-dvmon.dts \
	file://iio-tsl2x7x-fix-trigger.patch \
	file://fec-main-simulate-phy.patch \
	file://rafi-touchscreen-support.patch \
	file://rafi-touchscreen-event-report.patch \
	file://bpp-default-device-tree.patch \
	file://crypto-boot-warning-wrong-order.patch \
	file://0001-igb-kernel-driver-i210-add-device-id-0x1531-HYP-1131.patch \
	file://0002-igb-intel-i210-skip-eprom-error-HYP-11312.patch \
	file://mlb-pll.patch \
	file://bt565-start-pin.patch \
	file://adv739x-fix-instance.patch \
	file://imx-snvs-poweroff.patch \
	file://imx-power-down-device-tree.patch \
	file://imx-poweroff-restart.patch \
	file://0001-imx6-IPU-remove-dmsg-ipu-warnings-8byte-aligned-HYP-.patch \
	file://0001-mxc_vpu-fix-kmalloc-HYP-12884.patch \
	file://ldb-lvds-power-up-down-sequence.patch \
	file://0001-mcs7830-Fixed-MOSCHIP-driver-probe-error-110-HYP-132.patch \
"

do_configure_prepend() {
	# copy tw6869 driver code into kernel tree
	mkdir -p ${S}/drivers/media/pci/drtw6869
	cd ${S}/drivers/media/pci/drtw6869; tar cf - -C ${WORKDIR}/git.tw6869 . | tar xf -
	sed -i -e's/VIDEO_TW6869/VIDEO_DRTW6869/g' ${S}/drivers/media/pci/drtw6869/*
}

do_configure_prepend_himx0294() {
        cp ${WORKDIR}/defconfig ${S}/arch/arm/configs/himx0294_defconfig
	cp ${WORKDIR}/imx6qdl-himx0294-imoc.dtsi ${S}/arch/arm/boot/dts/imx6qdl-himx0294-imoc.dtsi
	cp ${WORKDIR}/imx6q-himx0294-imoc.dts ${S}/arch/arm/boot/dts/imx6q-himx0294-imoc.dts
	cp ${WORKDIR}/imx6qdl-himx0294-ivap.dtsi ${S}/arch/arm/boot/dts/imx6qdl-himx0294-ivap.dtsi
	cp ${WORKDIR}/imx6q-himx0294-ivap.dts ${S}/arch/arm/boot/dts/imx6q-himx0294-ivap.dts
        cp ${WORKDIR}/imx6qdl-himx0294-dvmon.dtsi ${S}/arch/arm/boot/dts/imx6qdl-himx0294-dvmon.dtsi
        cp ${WORKDIR}/imx6q-himx0294-dvmon.dts ${S}/arch/arm/boot/dts/imx6q-himx0294-dvmon.dts
}

do_configure_prepend_nitrogen6x() {
        cp ${WORKDIR}/defconfig ${S}/arch/arm/configs/nitrogen6x_defconfig
}

