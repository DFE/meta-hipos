# Use yocto kernel 3.17

COMPATIBLE_MACHINE = "hikirk"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-3.17:"

SRC_URI_append_hikirk =  " \
    file://defconfig \
    file://kirkwood-hikirk.dts \
    file://m25p80-noBP.patch \
"

SRC_URI +=  " \
    file://Add-Telit-modem-support.patch \
    file://gadgetfs-fmode_can_read.patch \
    file://net2280-fix-request-completion.patch \
"

do_patch_append() {
	cp ${WORKDIR}/kirkwood-hikirk.dts ${S}/arch/arm/boot/dts/
}

