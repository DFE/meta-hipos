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
	file://himx0294_imoc_defconfig \
	file://himx0294_ivap_defconfig \
	file://himx0294_dvmon_defconfig \
	file://himx0294.h \
	file://fw_env.config \
"

SRC_URI_append_hikirk = " \
	file://fw_env.config \
	file://0001-hikirk-Add-Kconfig.patch \
	file://fix-mmc-high-capacity.patch \
	file://Kconfig \
	file://Makefile \
	file://hikirk.c \
	file://hikirk.h \
	file://hikirk_defconfig \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend_himx0294 := "${THISDIR}/u-boot-himx0294:"
FILESEXTRAPATHS_prepend_hikirk := "${THISDIR}/u-boot-kirkwood:"

do_install_append_hikirk () {
	install -d ${D}/etc
	install -m 755 ${WORKDIR}/fw_env.config ${D}/etc/fw_env.config
}

do_configure_prepend_himx0294 () {
	mkdir -p ${S}/board/freescale/himx0294
	cp ${WORKDIR}/himx0294.c ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/Makefile ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/Kconfig ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/nitrogen6q.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/ddr-setup.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/1066mhz_4x128mx16.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/clocks.cfg ${B}/board/freescale/himx0294/

	cp ${WORKDIR}/himx0294_imoc_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294_ivap_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294_dvmon_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294.h ${B}/include/configs/
}

do_configure_hikirk() {
	mkdir -p ${S}/board/Marvell/hikirk
	cp ${WORKDIR}/hikirk.c ${B}/board/Marvell/hikirk/
	cp ${WORKDIR}/Makefile ${B}/board/Marvell/hikirk/
	cp ${WORKDIR}/Kconfig ${B}/board/Marvell/hikirk/

	cp ${WORKDIR}/hikirk_defconfig ${B}/configs/
	cp ${WORKDIR}/hikirk.h ${B}/include/configs/
}

do_install_append_himx0294 () {
	install -d ${D}/etc
	install -m 755 ${WORKDIR}/fw_env.config ${D}/etc/fw_env.config
}
