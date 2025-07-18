FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-${PV}:${THISDIR}/u-boot:${THISDIR}/files:"

SRC_URI:append:himx0294 = " \
	file://0001-himx0294-Add-Kconfig.patch \
	file://0001-himx-impec-revision-detection-pin.patch \
	file://himx0294.c \
	file://Makefile \
	file://Kconfig \
	file://nitrogen6q.cfg \
	file://nitrogen6q2g.cfg \
	file://mx6qp.cfg \
	file://ddr-setup.cfg \
	file://clocks.cfg \
	file://1066mhz_4x128mx16.cfg \
	file://1066mhz_4x256mx16.cfg \
	file://imximage_scm_lpddr2.cfg \
	file://himx0294_imoc_defconfig \
	file://himx0294_ivap_defconfig \
	file://himx0294_ivqp_defconfig \
	file://himx0294_dvmon_defconfig \
	file://himx0294.h \
	file://0001-himx0432-Add-Kconfig.patch \
	file://himx0294_impec_defconfig \
	file://himx0432.c \
	file://Makefile_himx0432 \
	file://Kconfig_himx0432 \
	file://himx0432.h \
	file://imximage-1GiB.cfg \
"

do_configure:prepend() {
	mkdir -p ${S}/board/freescale/himx0294
	cp ${WORKDIR}/himx0294.c ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/Makefile ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/Kconfig ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/nitrogen6q.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/nitrogen6q2g.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/mx6qp.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/ddr-setup.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/1066mhz_4x128mx16.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/1066mhz_4x256mx16.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/clocks.cfg ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/imximage_scm_lpddr2.cfg ${S}/board/freescale/himx0294/

	cp ${WORKDIR}/himx0294_imoc_defconfig ${S}/configs/
	cp ${WORKDIR}/himx0294_ivap_defconfig ${S}/configs/
	cp ${WORKDIR}/himx0294_ivqp_defconfig ${S}/configs/
	cp ${WORKDIR}/himx0294_dvmon_defconfig ${S}/configs/
	cp ${WORKDIR}/himx0294.h ${S}/include/configs/

        cp ${WORKDIR}/himx0294_impec_defconfig ${S}/configs/

        mkdir -p ${S}/board/freescale/himx0432
        cp ${WORKDIR}/Makefile_himx0432 ${S}/board/freescale/himx0432/Makefile
        cp ${WORKDIR}/Kconfig_himx0432 ${S}/board/freescale/himx0432/Kconfig
        cp ${WORKDIR}/himx0432.c ${S}/board/freescale/himx0432/
        cp ${WORKDIR}/imximage-1GiB.cfg ${S}/board/freescale/himx0432/
        cp ${WORKDIR}/himx0432.h ${S}/include/configs/
}

