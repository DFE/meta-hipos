DESCRIPTION = "make bootable sdcard for himx"

LICENSE = "MIT"

PR = "r4"

PACKAGES = " ${PN} "

SRC_URI = "file://himx-bootable-sdcard.sh"

S = "${WORKDIR}"

do_install() {
	install -d ${DEPLOY_DIR_IMAGE}
	install -m 0555 ${WORKDIR}/himx-bootable-sdcard.sh ${DEPLOY_DIR_IMAGE}/himx-bootable-sdcard.sh
}

do_configure[noexec] = "1"
do_build[noexec] = "1"
do_compile[noexec] = "1"
do_package[noexec] = "1"
do_packagedata[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"

