# we've problems with parallel make when building for multiconfig
PARALLEL_MAKE = ""

SRC_URI_append_himx0294 = " \
	file://0001-himx0294-Add-Kconfig.patch \
	file://himx0294.c \
	file://Makefile \
	file://Kconfig \
	file://nitrogen6q.cfg \
	file://ddr-setup.cfg \
	file://clocks.cfg \
	file://1066mhz_4x128mx16.cfg \
	file://imximage_scm_lpddr2.cfg \
	file://himx0294_imoc_defconfig \
	file://himx0294_ivap_defconfig \
	file://himx0294_ivqp_defconfig \
	file://himx0294_dvmon_defconfig \
	file://himx0294_ipcam_defconfig \
	file://himx0294.h \
	file://fw_env.config \
	file://fw_env-ipcam.config \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend_himx0294 := "${THISDIR}/u-boot-himx0294:"

do_configure_prepend_himx0294 () {
	mkdir -p ${S}/board/freescale/himx0294
	cp ${WORKDIR}/himx0294.c ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/Makefile ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/Kconfig ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/nitrogen6q.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/ddr-setup.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/1066mhz_4x128mx16.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/clocks.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/imximage_scm_lpddr2.cfg ${S}/board/freescale/himx0294/

	cp ${WORKDIR}/himx0294_imoc_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294_ivap_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294_ivqp_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294_dvmon_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294_ipcam_defconfig ${S}/configs/
	cp ${WORKDIR}/himx0294.h ${B}/include/configs/
}

do_install_append_himx0294 () {
	install -d ${D}/etc
	install -m 755 ${WORKDIR}/fw_env.config ${D}/etc/fw_env.config
	install -m 755 ${WORKDIR}/fw_env-ipcam.config ${D}/etc/fw_env-ipcam.config
}
