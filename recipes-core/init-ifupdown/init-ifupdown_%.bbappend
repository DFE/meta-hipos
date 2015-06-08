FILESEXTRAPATHS_prepend := "${THISDIR}/init-ifupdown:"

SRC_URI += " file://99-ifupdown.conf "

do_install_append() {
	# install sysctl configurations
	install -d ${D}${sysconfdir}/sysctl.d
	install -m 0644 ${S}/99-ifupdown.conf ${D}${sysconfdir}/sysctl.d
}
