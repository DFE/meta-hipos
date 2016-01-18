CRIPTION = "frontend for the i.MX6 VPU hardware video engine"
HOMEPAGE = "https://github.com/Freescale/libimxvpuapi"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://LICENSE;md5=38fa42a5a6425b26d2919b17b1527324"
SECTION = "multimedia"
DEPENDS = "imx-vpu"

SRCBRANCH ?= "master"
SRCREV = "58ad556180fc3868f26af0a55504dc461e2fb7e9"
SRC_URI = "git://github.com/Freescale/libimxvpuapi.git;branch=${SRCBRANCH}"

S = "${WORKDIR}/git"

inherit waf pkgconfig

COMPATIBLE_MACHINE = "(mx6q|mx6dl)"

FILES_${PN} += " \
	/usr/lib64/libimxvpuapi.so.0.10.1 \
	/usr/lib64/pkgconfig/libimxvpuapi.pc \
"

do_install(){
	install -d ${D}/usr/include/imxvpuapi
	install -m 0644 ${S}/imxvpuapi/imxvpuapi.h ${D}/usr/include/imxvpuapi
	install -d ${D}/usr/lib/pkgconfig
	install -m 0755 ${S}/build/libimxvpuapi.so.0.10.1  ${D}/usr/lib/
	ln -s ${S}/build/libimxvpuapi.so.0.10.1 ${S}/build/libimxvpuapi.so.0
	ln -s ${S}/build/libimxvpuapi.so.0.10.1 ${S}/build/libimxvpuapi.so
	install -m 0755 ${S}/build/libimxvpuapi.pc ${D}/usr/lib/pkgconfig/
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

