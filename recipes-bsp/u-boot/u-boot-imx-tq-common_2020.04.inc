SECTION = "bootloaders"

LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"

SRCREV = "04f8d2b712f74180d0bf58bb65f584f46304fd31"
SRCBRANCH = "TQMa8-v2020.04_imx_5.4.70_2.3.0"

TQ_GIT_BASEURL = "git://github.com/tq-systems"
TQ_GIT_PROTOCOL = "https"

SRC_URI = "\
    ${TQ_GIT_BASEURL}/u-boot-tqmaxx.git;protocol=${TQ_GIT_PROTOCOL};branch=${SRCBRANCH} \
"

DEPENDS:append = " bison-native"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "tqma8xx"
COMPATIBLE_MACHINE:append = "|tqma8xxs"
COMPATIBLE_MACHINE:append = "|tqma8qm"
COMPATIBLE_MACHINE:append = "|tqma8mpxl"
COMPATIBLE_MACHINE:append = "|tqma8mq"
COMPATIBLE_MACHINE:append = "|tqma8mxml"
COMPATIBLE_MACHINE:append = "|tqma8mxnl"
COMPATIBLE_MACHINE:append = "|himx8"
COMPATIBLE_MACHINE:append = "|mx8-nxp-bsp"
