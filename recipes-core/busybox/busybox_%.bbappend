# look for files in the layer first
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://busybox-tar.sh \
"

do_install_append() {
	install -d ${D}${sysconfdir}/profile.d
	install -m 0644 ${WORKDIR}/busybox-tar.sh ${D}${sysconfdir}/profile.d/
}
