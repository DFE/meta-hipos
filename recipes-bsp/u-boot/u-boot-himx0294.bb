require recipes-bsp/u-boot/u-boot_2016.03.bb

COMPATIBLE_MACHINE = "himx0294"

PR = "r8"

SRC_URI_append_himx0294 = " \
	file://0001-himx0294-Add-Kconfig.patch \
	file://himx0294.c \
	file://Makefile \
	file://Kconfig \
	file://nitrogen6q.cfg \
	file://nitrogen6q2g.cfg \
	file://ddr-setup.cfg \
	file://clocks.cfg \
	file://1066mhz_4x128mx16.cfg \
	file://1066mhz_4x256mx16.cfg \
	file://himx0294_imoc_defconfig \
	file://himx0294_ivap_defconfig \
	file://himx0294_ivqp_defconfig \
	file://himx0294_dvmon_defconfig \
	file://himx0294.h \
"

do_configure_prepend() {
	mkdir -p ${S}/board/freescale/himx0294
	cp ${WORKDIR}/himx0294.c ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/Makefile ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/Kconfig ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/nitrogen6q.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/nitrogen6q2g.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/ddr-setup.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/1066mhz_4x128mx16.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/1066mhz_4x256mx16.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/clocks.cfg ${B}/board/freescale/himx0294/

	cp ${WORKDIR}/himx0294_imoc_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294_ivap_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294_ivqp_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294_dvmon_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294.h ${B}/include/configs/
}

