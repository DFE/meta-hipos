# we've problems with parallel make when building for multiconfig
PARALLEL_MAKE = ""

LIC_FILES_CHKSUM_himx0438 = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"
SRCBRANCH_himx0438        = "imx_v2018.03_4.14.98_2.0.0_ga"
SRC_URI_himx0438 = "git://source.codeaurora.org/external/imx/uboot-imx.git;protocol=https;branch=${SRCBRANCH}"
SRCREV_himx0438  = "0d6d8807793e74402e23772062469aeb4808dd48"

SRC_URI_append_himx0438 = " \
	file://fw_env.config \
"

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
	file://0001-himx0432-Add-Kconfig.patch \
	file://himx0294_impec_defconfig \
	file://himx0432.c \
	file://Makefile_himx0432 \
	file://Kconfig_himx0432 \
	file://himx0432.h \
	file://imximage-1GiB.cfg \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend_himx0294 := "${THISDIR}/u-boot-${PV}/himx0294:"
FILESEXTRAPATHS_prepend_himx0438 := "${THISDIR}/u-boot-${PV}/himx0438:"

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

        cp ${WORKDIR}/himx0294_impec_defconfig ${S}/configs/

        mkdir -p ${S}/board/freescale/himx0432
        cp ${WORKDIR}/Makefile_himx0432 ${S}/board/freescale/himx0432/Makefile
        cp ${WORKDIR}/Kconfig_himx0432 ${S}/board/freescale/himx0432/Kconfig
        cp ${WORKDIR}/himx0432.c ${S}/board/freescale/himx0432/
        cp ${WORKDIR}/imximage-1GiB.cfg ${S}/board/freescale/himx0432/
        cp ${WORKDIR}/himx0432.h ${S}/include/configs/
}

do_install_append_himx0294 () {
	install -d ${D}/etc
	install -m 755 ${WORKDIR}/fw_env.config ${D}/etc/fw_env.config
	install -m 755 ${WORKDIR}/fw_env-ipcam.config ${D}/etc/fw_env-ipcam.config
}

do_install_append_himx0438 () {
	install -d ${D}/etc
	install -m 755 ${WORKDIR}/fw_env.config ${D}/etc/fw_env.config
}
