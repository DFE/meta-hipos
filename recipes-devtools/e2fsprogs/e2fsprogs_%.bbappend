FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://0001-mke2fs.conf-define-a-short-proceed_delay-of-1-sec-HY.patch \
	file://0001-ext4-64bit-feature-not-activated-by-default.patch \
	file://batch-calls-to-ext2fs_zero_blocks2.patch \
"
