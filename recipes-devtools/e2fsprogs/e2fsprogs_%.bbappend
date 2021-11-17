FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://0001-mke2fs.conf-define-a-short-proceed_delay-of-1-sec-HY.patch \
	file://0001-ext4-64bit-feature-not-activated-by-default.patch \
"
