
COMPATIBLE_MACHINE = "(himx0294|himx|nitrogen6x|nitrogen6x-lite|mx6)"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-boundary-4.1.15:"

# use HEAD revision of special tw6869 driver
SRCREV_FORMAT = "tw6869"
SRCREV_tw6869 = "${AUTOREV}"
PV_append = "+tw6869gitr${SRCPV}"

# do not rename this variable because it will be processed by some
# external tooling (see https://dresearchfe.jira.com/browse/HYP-14343)
DRSRCBRANCH="4.8"

SRC_URI_append = " \
	git://github.com/DFE/tw6869.git;protocol=https;destsuffix=git.tw6869;name=tw6869;branch=${DRSRCBRANCH} \
	file://0001-add-tw6869-to-parent-Kconfig-and-Makefile-HYP-11342.patch \
	file://mmc-sd-show-ssr-in-sysfs.patch \
	file://ENET_REF_CLK.patch \
	file://support-mitsubishi-touch-controller.patch \
	file://fix-fb_memcpy_tofb.patch \
	file://asix-usb-nic.patch \
"

#	file://0001-HYP-12986-run-tasklet-function-of-UART-DMA-within-IS.patch
#	file://imx-sdma-update-channel.patch
#	file://0001-libahci_platform-add-missing-symbol-export.patch

SRC_URI_append_himx0294 = " \
	file://imx6qdl-himx0294-imoc.dtsi \
	file://imx6q-himx0294-imoc.dts \
	file://imx6qdl-himx0294-imoc-2.dtsi \
	file://imx6q-himx0294-imoc-2.dts \
	file://imx6qdl-himx0294-ivap.dtsi \
	file://imx6q-himx0294-ivap.dts \
        file://imx6qdl-himx0294-dvmon.dtsi \
        file://imx6q-himx0294-dvmon.dts \
        file://imx6qdl-himx0294-dvmon-2.dtsi \
        file://imx6q-himx0294-dvmon-2.dts \
        file://imx6qdl-himx0294-dvrec.dtsi \
        file://imx6q-himx0294-dvrec.dts \
        file://imx6qp-himx0294-dvrec.dts \
        file://imx6qscm-himx0294-ipcam.dtsi \
        file://imx6qscm-himx0294-ipcam.dts \
	file://iio-tsl2x7x-fix-trigger.patch \
	file://fec-main-simulate-phy.patch \
	file://rafi-touchscreen-support.patch \
	file://rafi-touchscreen-event-report.patch \
	file://0001-igb-kernel-driver-i210-add-device-id-0x1531-HYP-1131.patch \
	file://0002-igb-intel-i210-skip-eprom-error-HYP-11312.patch \
	file://mlb-pll.patch \
	file://mlb-disable-kconfig.patch \
	file://bt565-start-pin.patch \
	file://adv739x-fix-instance.patch \
	file://imx-poweroff-restart.patch \
	file://0001-imx6-IPU-remove-dmsg-ipu-warnings-8byte-aligned-HYP-.patch \
	file://0001-mxc_vpu-fix-kmalloc-HYP-12884.patch \
	file://ldb-lvds-power-up-down-sequence.patch \
	file://0001-mcs7830-Fixed-MOSCHIP-driver-probe-error-110-HYP-132.patch \
	file://0001-DCIC-ioctl-improved-to-get-real-checksums-HYP-16117.patch \
	file://ahci_imx-reset-sata-phy.patch \
	file://imx-watchdog-Assert-wdog_b-reset.patch \
	file://ov5640-Fix-exposure-and-white-balance.patch \
"

#	file://bpp-default-device-tree.patch
#	file://crypto-boot-warning-wrong-order.patch

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
	cp ${WORKDIR}/imx6qdl-himx0294-imoc-2.dtsi ${S}/arch/arm/boot/dts/imx6qdl-himx0294-imoc-2.dtsi
	cp ${WORKDIR}/imx6q-himx0294-imoc-2.dts ${S}/arch/arm/boot/dts/imx6q-himx0294-imoc-2.dts
	cp ${WORKDIR}/imx6qdl-himx0294-ivap.dtsi ${S}/arch/arm/boot/dts/imx6qdl-himx0294-ivap.dtsi
	cp ${WORKDIR}/imx6q-himx0294-ivap.dts ${S}/arch/arm/boot/dts/imx6q-himx0294-ivap.dts
        cp ${WORKDIR}/imx6qdl-himx0294-dvmon.dtsi ${S}/arch/arm/boot/dts/imx6qdl-himx0294-dvmon.dtsi
        cp ${WORKDIR}/imx6q-himx0294-dvmon.dts ${S}/arch/arm/boot/dts/imx6q-himx0294-dvmon.dts
        cp ${WORKDIR}/imx6qdl-himx0294-dvmon-2.dtsi ${S}/arch/arm/boot/dts/imx6qdl-himx0294-dvmon-2.dtsi
        cp ${WORKDIR}/imx6q-himx0294-dvmon-2.dts ${S}/arch/arm/boot/dts/imx6q-himx0294-dvmon-2.dts
        cp ${WORKDIR}/imx6qdl-himx0294-dvrec.dtsi ${S}/arch/arm/boot/dts/imx6qdl-himx0294-dvrec.dtsi
        cp ${WORKDIR}/imx6q-himx0294-dvrec.dts ${S}/arch/arm/boot/dts/imx6q-himx0294-dvrec.dts
        cp ${WORKDIR}/imx6qp-himx0294-dvrec.dts ${S}/arch/arm/boot/dts/imx6qp-himx0294-dvrec.dts
        cp ${WORKDIR}/imx6qscm-himx0294-ipcam.dtsi ${S}/arch/arm/boot/dts/imx6qscm-himx0294-ipcam.dtsi
        cp ${WORKDIR}/imx6qscm-himx0294-ipcam.dts ${S}/arch/arm/boot/dts/imx6qscm-himx0294-ipcam.dts
}

do_configure_prepend_nitrogen6x() {
        cp ${WORKDIR}/defconfig ${S}/arch/arm/configs/nitrogen6x_defconfig
}

