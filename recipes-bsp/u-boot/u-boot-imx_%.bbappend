FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-imx:${THISDIR}/files:"

SRC_URI:append:himx8 = " \
	file://lpddr4_timing.c \
	file://himx8_repro_defconfig \
	file://imx8mp_evk.h \
"

do_configure:prepend:himx8() {
        cp ${WORKDIR}/lpddr4_timing.c ${S}/board/freescale/imx8mp_evk/
	cp ${WORKDIR}/himx8_repro_defconfig ${S}/configs/
	cp ${WORKDIR}/imx8mp_evk.h ${S}/include/configs/
}

