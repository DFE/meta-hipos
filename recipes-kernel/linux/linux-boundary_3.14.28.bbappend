
COMPATIBLE_MACHINE = "(himx0294|himx0280|himx|nitrogen6x|nitrogen6x-lite|mx6)"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-boundary-3.14.28:"

# use HEAD revision of special tw6869 driver
SRCREV_FORMAT = "tw6869"
SRCREV_tw6869 = "${AUTOREV}"
PV_append = "+tw6869gitr${SRCPV}"

SRC_URI_append = " \
	git://github.com/DFE/tw6869.git;protocol=https;destsuffix=git.tw6869;name=tw6869 \
	file://0001-add-tw6869-to-parent-Kconfig-and-Makefile-HYP-11342.patch \
"

SRC_URI_append_himx0280 =  " \
	file://defconfig \
	file://imx6qdl-himx0280.dtsi \
	file://imx6q-himx0280.dts \
	file://0001-net-core-tso.c-implicit-declaration-of-function-tcp_.patch \
	file://arm-dts-imx-fix-invalid-address-cells.patch \
	file://crypto-boot-warning-wrong-order.patch \
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
"

do_configure_prepend() {
	# copy tw6869 driver code into kernel tree
	mkdir -p ${S}/drivers/media/pci/tw6869
	cd ${S}/drivers/media/pci/tw6869; tar cf - -C ${WORKDIR}/git.tw6869 . | tar xf -
}

do_configure_prepend_himx0280() {
	cp ${WORKDIR}/defconfig ${S}/arch/arm/configs/himx0280_defconfig
	cp ${WORKDIR}/imx6qdl-himx0280.dtsi ${S}/arch/arm/boot/dts/imx6qdl-himx0280.dtsi
	cp ${WORKDIR}/imx6q-himx0280.dts ${S}/arch/arm/boot/dts/imx6q-himx0280.dts
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

