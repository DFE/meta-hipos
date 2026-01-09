FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-${PV}:${THISDIR}/u-boot:${THISDIR}/files:"

SRC_URI:append:himx0294 = " \
	file://0001-himx0294-Add-Kconfig.patch \
	file://0001-himx0432-Add-Kconfig.patch \
	file://himx0294.c \
	file://himx0294.h \
	file://himx0432.c \
	file://himx0432.h \
	file://Makefile \
	file://Kconfig \
	file://nitrogen6q.cfg.template \
	file://nitrogen6q2g.cfg.template \
	file://mx6qp.cfg.template \
	file://ddr-setup.cfg.template \
	file://clocks.cfg.template \
	file://1066mhz_4x128mx16.cfg.template \
	file://1066mhz_4x256mx16.cfg.template \
	file://imximage_scm_lpddr2.cfg.template \
	file://himx0294_imoc_defconfig \
	file://himx0294_ivap_defconfig \
	file://himx0294_ivqp_defconfig \
	file://himx0294_dvmon_defconfig \
	file://himx0294_impec_defconfig \
	file://Makefile_himx0432 \
	file://Kconfig_himx0432 \
	file://imximage-1GiB.cfg.template \
	file://imx6q-himx0294.dts \
	file://imx6q-himx0294-dvmon.dts \
	file://imx6ull-himx0432.dts \
    file://0002-crypto-fsl_hash-fix-flush-dcache-alignment-in-caam_h.patch \
"

SRC_URI:append:himx0294:hipos-cyber-security = " \
    file://0003-bootm-Authenticate-image-with-IMX-HAB.patch \
"

do_configure:prepend() {
	mkdir -p ${S}/board/freescale/himx0294
	cp ${WORKDIR}/himx0294.c ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/Makefile ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/Kconfig ${S}/board/freescale/himx0294/
	cp ${WORKDIR}/nitrogen6q.cfg.template ${S}/board/freescale/himx0294/nitrogen6q.cfg
	cp ${WORKDIR}/nitrogen6q2g.cfg.template ${S}/board/freescale/himx0294/nitrogen6q2g.cfg
	cp ${WORKDIR}/mx6qp.cfg.template ${S}/board/freescale/himx0294/mx6qp.cfg
	cp ${WORKDIR}/ddr-setup.cfg.template ${S}/board/freescale/himx0294/ddr-setup.cfg
	cp ${WORKDIR}/1066mhz_4x128mx16.cfg.template ${S}/board/freescale/himx0294/1066mhz_4x128mx16.cfg
	cp ${WORKDIR}/1066mhz_4x256mx16.cfg.template ${S}/board/freescale/himx0294/1066mhz_4x256mx16.cfg
	cp ${WORKDIR}/clocks.cfg.template ${S}/board/freescale/himx0294/clocks.cfg
	cp ${WORKDIR}/imximage_scm_lpddr2.cfg.template ${S}/board/freescale/himx0294/imximage_scm_lpddr2.cfg

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
        cp ${WORKDIR}/imximage-1GiB.cfg.template ${S}/board/freescale/himx0432/imximage-1GiB.cfg
        cp ${WORKDIR}/himx0432.h ${S}/include/configs/

        cp ${WORKDIR}/imx6q-himx0294.dts ${S}/arch/arm/dts/
        cp ${WORKDIR}/imx6q-himx0294-dvmon.dts ${S}/arch/arm/dts/
        cp ${WORKDIR}/imx6ull-himx0432.dts ${S}/arch/arm/dts/
}

## HABv4 Secure Boot ##
# loosely based on:
# https://github.com/iris-GmbH/meta-iris-base/blob/develop/dynamic/freescale-layer/recipes-bsp/imx-mkimage/imx-boot_%25.bbappend

inherit hab-compatibility-check

SRC_URI:append:himx0294 = " \
    file://${HAB_DIR}/csf.cfg \
"

DEPENDS:append = " \
    cst-native \
    cst-signer-native \
"

SIGN_DIR="${B}/sign"

do_compile:append() {
    mkdir -p "${SIGN_DIR}"
    for config in ${UBOOT_MACHINE}; do
        i=$(expr $i + 1);
        for type in ${UBOOT_SIGNED}; do
            j=$(expr $j + 1);
            if [ $j -eq $i ]
            then
                sign_boot_image_config $config $type
            fi
        done
        unset j
    done
    unset i
}

sign_boot_image_config() {
    config=$1
    type=$2

    BOOT_IMAGE="${UBOOT_BINARYNAME}-${type}"
    bbnote "Signing boot image ${BOOT_IMAGE}"

    # Generate signed image using cst_signer
    cd "${SIGN_DIR}"
    cp "${B}/${config}/${UBOOT_BINARY}" "${SIGN_DIR}/${BOOT_IMAGE}"
    CST_EXE_PATH=cst CST_PATH=${HAB_DIR} cst_signer -d -i ${SIGN_DIR}/${BOOT_IMAGE} -c ${HAB_DIR}/csf.cfg
    if [ ! -e "${SIGN_DIR}/signed-${BOOT_IMAGE}" ]; then
        bbfatal "Image signing failed"
    fi
    check_csf_compatibility ${SIGN_DIR}/signed-${BOOT_IMAGE}
    mv ${SIGN_DIR}/signed-${BOOT_IMAGE} ${SIGN_DIR}/${BOOT_IMAGE}.signed
}

do_install:append() {
    for signed in ${SIGN_DIR}/*.signed;
    do
        install -D -m 644 ${signed} ${D}/boot/
    done
}

do_deploy:append() {
    for signed in ${SIGN_DIR}/*.signed;
    do
        BOOT_IMAGE=$(basename "$signed" | sed -e 's/.signed//')
        type=$(echo "$BOOT_IMAGE" | sed -e "s/${UBOOT_BINARYNAME}-//")
        DEPLOY_NAME="${BOOT_IMAGE}-${PV}-${PR}.${UBOOT_SUFFIX}.signed"
        install -D -m 644 ${signed} ${DEPLOYDIR}/${DEPLOY_NAME}
        cd ${DEPLOYDIR}
        ln -sf ${DEPLOY_NAME} ${UBOOT_SYMLINK}-${type}.signed
        ln -sf ${DEPLOY_NAME} ${UBOOT_BINARY}-${type}.signed
    done
}
