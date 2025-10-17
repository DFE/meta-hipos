FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-WA-for-decoder-close-bit-buffer-flush-HYP-20606.patch \
	file://waf \
"

do_configure:prepend() {
    # Update Waf build script to Python3-compatible version
    cp ${WORKDIR}/waf ${S}/
}
