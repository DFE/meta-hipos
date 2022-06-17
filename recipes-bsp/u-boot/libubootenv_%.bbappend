FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-2022.01:${THISDIR}/libubootenv:"

SRC_URI:append:himx0294 = " \
	file://fw_env.config \
	file://fw_env-ipcam.config \
"

do_install:append:himx0294 () {
	install -d ${D}/etc
	install -m 755 ${WORKDIR}/fw_env.config ${D}/etc/fw_env.config
	install -m 755 ${WORKDIR}/fw_env-ipcam.config ${D}/etc/fw_env-ipcam.config
}

