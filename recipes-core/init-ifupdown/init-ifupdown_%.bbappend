# look for files in the layer first
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://99-ifupdown.conf \
             file://ethconfig \
"

do_install_append() {
	# install sysctl configurations
	install -d ${D}${sysconfdir}/sysctl.d
	install -m 0644 ${S}/99-ifupdown.conf ${D}${sysconfdir}/sysctl.d
	install -d ${D}${sysconfdir}/network/if-up.d
	install -m 0755 ${S}/ethconfig ${D}${sysconfdir}/network/if-up.d
}

pkg_postinst_ontarget_${PN}() {
	update-rc.d networking defaults
}

