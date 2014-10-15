SUMMARY = "U-Boot bootloader fw_printenv/setenv utilities"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://README;beginline=5;endline=5;md5=0299932579b935087822c54ba998a097"
SECTION = "bootloader"
DEPENDS = "mtd-utils"

# This revision corresponds to the tag "v2014.07"
# We use the revision in order to avoid having to fetch it from the
# repo during parse
SRCREV = "524123a70761110c5cf3ccc5f52f6d4da071b959"

PV = "v2014.07+git${SRCPV}"

SRC_URI = "git://git.denx.de/u-boot.git;branch=master;protocol=git"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = 'CROSS_COMPILE=${TARGET_PREFIX} CC="${TARGET_PREFIX}gcc ${TOOLCHAIN_OPTIONS}"'

inherit uboot-config

do_compile () {
  oe_runmake ${UBOOT_MACHINE}
  oe_runmake env
}

do_install () {
  install -d ${D}${base_sbindir}
  install -m 755 ${S}/tools/env/fw_printenv ${D}${base_sbindir}/fw_printenv
  install -m 755 ${S}/tools/env/fw_printenv ${D}${base_sbindir}/fw_setenv
}

PACKAGE_ARCH = "${MACHINE_ARCH}"
