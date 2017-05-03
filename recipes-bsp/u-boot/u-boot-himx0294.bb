require recipes-bsp/u-boot/u-boot_2016.03.bb

COMPATIBLE_MACHINE = "himx0294"

PR = "r10"

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
	file://imximage_scm_lpddr2.cfg \
	file://himx0294_imoc_defconfig \
	file://himx0294_ivap_defconfig \
	file://himx0294_ivqp_defconfig \
	file://himx0294_dvmon_defconfig \
	file://himx0294_ipcam_defconfig \
	file://himx0294.h \
"

do_configure_prepend() {
	mkdir -p ${S}/board/freescale/himx0294
	cp ${WORKDIR}/himx0294.c ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/Makefile ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/Kconfig ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/nitrogen6q.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/nitrogen6q2g.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/ddr-setup.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/1066mhz_4x128mx16.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/1066mhz_4x256mx16.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/clocks.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/imximage_scm_lpddr2.cfg ${S}/board/freescale/himx0294/

	cp ${WORKDIR}/himx0294_imoc_defconfig ${S}/configs/
	cp ${WORKDIR}/himx0294_ivap_defconfig ${S}/configs/
	cp ${WORKDIR}/himx0294_ivqp_defconfig ${S}/configs/
	cp ${WORKDIR}/himx0294_dvmon_defconfig ${S}/configs/
	cp ${WORKDIR}/himx0294_ipcam_defconfig ${S}/configs/
	cp ${WORKDIR}/himx0294.h ${S}/include/configs/
}

