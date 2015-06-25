FILESEXTRAPATHS_prepend := "${THISDIR}/init-ifupdown:"

SRC_URI += " file://99-ifupdown.conf \
             file://systemd-nokill \
             file://systemd-kill \
             file://0001-Hipos-new-default-etc-network-interfaces.patch \
"

do_install_append() {
	# install sysctl configurations
	install -d ${D}${sysconfdir}/sysctl.d
	install -m 0644 ${S}/99-ifupdown.conf ${D}${sysconfdir}/sysctl.d
	install -d ${D}${sysconfdir}/network/if-up.d
	install -m 0755 ${S}/systemd-nokill ${D}${sysconfdir}/network/if-up.d
	install -d ${D}${sysconfdir}/network/if-post-down.d
	install -m 0755 ${S}/systemd-kill ${D}${sysconfdir}/network/if-post-down.d
}

pkg_postinst_${PN}() {
	update-rc.d networking defaults
}

