inherit kernel_wireless_regdb

COMPATIBLE_MACHINE = "(himx0294|himx-nxp-bsp|nitrogen6x|nitrogen6x-lite|mx6-nxp-bsp)"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-boundary-5.15:"

# use HEAD revision of special tw6869 driver
SRCREV_FORMAT = "tw6869"
SRCREV_tw6869 = "${AUTOREV}"
PV:append = "+tw6869gitr${SRCPV}"

# unset KBUILD_DEFCONFIG. To avoid that the defconfig must be located in kernel
# source tree.
KBUILD_DEFCONFIG = ""

# do not rename this variable because it will be processed by some
# external tooling (see https://dresearchfe.jira.com/browse/HYP-14343)
DRSRCBRANCH="master"

SRC_URI:append = " \
	git://github.com/DFE/tw6869.git;protocol=https;destsuffix=git.tw6869;name=tw6869;branch=${DRSRCBRANCH} \
	file://defconfig \
	file://support-mitsubishi-touch-controller.patch \
	file://0001-add-tw6869-to-parent-Kconfig-and-Makefile-HYP-11342.patch \
	file://0001-Add-IPU_QUEUE_TASK-mutex-HYP-19476.patch \
"


SRC_URI:append:himx0294 = " \
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
        file://imx6ull-himx0294-impec.dts \
        file://imx6ull-himx0294-impec-2.dts \
	file://fec-main-simulate-phy.patch \
	file://0001-igb-kernel-driver-i210-add-device-id-0x1531-HYP-1131.patch \
	file://0002-igb-intel-i210-skip-eprom-error-HYP-11312.patch \
	file://bt565-start-pin.patch \
	file://adv739x-fix-instance.patch \
	file://0001-imx6-IPU-remove-dmsg-ipu-warnings-8byte-aligned-HYP-.patch \
	file://0001-mxc_vpu-fix-kmalloc-HYP-12884.patch \
	file://ldb-lvds-power-up-down-sequence.patch \
	file://0001-DCIC-ioctl-improved-to-get-real-checksums-HYP-16117.patch \
	file://0001-mcs7830-Fixed-MOSCHIP-driver-probe-error-110-HYP-132.patch \ 
        file://set-pci-nomsi-kparam-as-default-HYP-19000.patch \
	file://pixcir-touch-moving-mode-HYP-19464.patch \
	file://0001-Disable-workaround-MLK-11444.patch \
	file://0001-ahci_imx-fix-module-unload-HYP-23856.patch \
	file://0001-Revert-leds-pwm-add-note-frequency-support.patch \
	file://0001-spi-imx-Restore-driver-version-HYP-24810.patch \
	file://0001-fec_main-Add-dma_rmb-HYP-25259.patch \
	file://0001-Add-parameter-to-module-brcmfmac-HYP-29550.patch \
"

#	file://rafi-touchscreen-support.patch 
#	file://rafi-touchscreen-event-report.patch 

do_kernel_configme:prepend() {
	# copy tw6869 driver code into kernel tree
	mkdir -p ${S}/drivers/media/pci/drtw6869
	cd ${S}/drivers/media/pci/drtw6869; tar cf - -C ${WORKDIR}/git.tw6869 . | tar xf -
	sed -i -e's/VIDEO_TW6869/VIDEO_DRTW6869/g' ${S}/drivers/media/pci/drtw6869/*
}

do_configure:prepend:himx0294() {
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
        cp ${WORKDIR}/imx6ull-himx0294-impec.dts ${S}/arch/arm/boot/dts/imx6ull-himx0294-impec.dts
        cp ${WORKDIR}/imx6ull-himx0294-impec-2.dts ${S}/arch/arm/boot/dts/imx6ull-himx0294-impec-2.dts
}

do_configure:prepend:nitrogen6x() {
        cp ${WORKDIR}/defconfig ${S}/arch/arm/configs/nitrogen6x_defconfig
}

