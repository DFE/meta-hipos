LICENSE_himx0280 = "GPLv2+"
LIC_FILES_CHKSUM_himx0280 = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI_himx0280 =  "git://github.com/DFE/u-boot.git;protocol=http;branch=master"
SRC_URI_himx0280[md5sum] = "8c5e4dc994b7c65c8d4dcc365f8ee8a6"
SRC_URI_himx0280[sha256sum] = "e93e2a2890188d6d8153ec4f16b80ee85d5e255485f46205e623de858cbf0ad4"
SRCREV_himx0280 = "ea26efa27897ba6e238fb823a6d5d09433e07da6"

SRC_URI_himx0294 = "git://github.com/Freescale/u-boot-imx.git;branch=${SRCBRANCH}"
SRCREV_himx0294 = "75ce95e627609c9b9e537e935e69c4ecef26c8f7"
SRCBRANCH_himx0294 = "patches-2014.10"

SRC_URI_himx0322 = "git://github.com/Freescale/u-boot-imx.git;branch=${SRCBRANCH}"
SRCREV_himx0322 = "75ce95e627609c9b9e537e935e69c4ecef26c8f7"
SRCBRANCH_himx0322 = "patches-2014.10"

SRC_URI_append_himx0294 = " \
	file://0001-himx0294-Add-Kconfig.patch \
	file://himx0294.c \
	file://Makefile \
	file://Kconfig \
	file://nitrogen6q.cfg \
	file://ddr-setup.cfg \
	file://clocks.cfg \
	file://1066mhz_4x128mx16.cfg \
	file://himx0294_defconfig \
	file://himx0294.h \
	file://fw_env.config \
"

SRC_URI_append_himx0322 = " \
	file://0001-himx0294-Add-Kconfig.patch \
	file://himx0294.c \
	file://Makefile \
	file://Kconfig \
	file://nitrogen6q.cfg \
	file://ddr-setup.cfg \
	file://clocks.cfg \
	file://1066mhz_4x128mx16.cfg \
	file://himx0294_defconfig \
	file://himx0294.h \
	file://fw_env.config \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

FILESEXTRAPATHS_prepend_himx0294 := "${THISDIR}/u-boot-himx0294:"

FILESEXTRAPATHS_prepend_himx0322 := "${THISDIR}/u-boot-himx0294:"

SRC_URI_append_hikirk +=  " file://fw_env.config \
	      file://hikirk-board-support.patch \
	    "

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

	cp ${WORKDIR}/himx0294_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294.h ${B}/include/configs/
}

do_configure_prepend_himx0322 () {
	mkdir -p ${S}/board/freescale/himx0294
	cp ${WORKDIR}/himx0294.c ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/Makefile ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/Kconfig ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/nitrogen6q.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/ddr-setup.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/1066mhz_4x128mx16.cfg ${B}/board/freescale/himx0294/
	cp ${WORKDIR}/clocks.cfg ${B}/board/freescale/himx0294/

	cp ${WORKDIR}/himx0294_defconfig ${B}/configs/
	cp ${WORKDIR}/himx0294.h ${B}/include/configs/
}

do_install_append_himx0294 () {
	install -d ${D}/etc
	install -m 755 ${WORKDIR}/fw_env.config ${D}/etc/fw_env.config
}

do_install_append_himx0322 () {
	install -d ${D}/etc
	install -m 755 ${WORKDIR}/fw_env.config ${D}/etc/fw_env.config
}

