require u-boot.inc

# To build u-boot for your machine, provide the following lines in your machine
# config, replacing the assignments as appropriate for your machine.
# UBOOT_MACHINE = "omap3_beagle_config"
# UBOOT_ENTRYPOINT = "0x80008000"
# UBOOT_LOADADDRESS = "0x80008000"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://README;beginline=5;endline=5;md5=0299932579b935087822c54ba998a097"

# This revision corresponds to the tag "v2014.07"
# We use the revision in order to avoid having to fetch it from the repo during parse
SRCREV = "524123a70761110c5cf3ccc5f52f6d4da071b959"

PV = "v2014.07+git${SRCPV}"

SRC_URI = "git://git.denx.de/u-boot.git;branch=master \
"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"
