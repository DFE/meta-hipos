# [PATCH] {aes-armv4|bsaes-armv7|sha256-armv4}.pl: make it work with
# binutils-2.29
#
# It's not clear if it's a feature or bug, but binutils-2.29[.1]
# interprets 'adr' instruction with Thumb2 code reference differently,
# in a way that affects calculation of addresses of constants' tables.

FILESEXTRAPATHS_prepend := "${THISDIR}/openssl-1.0.2l:"

SRC_URI_append = " \
	file://0001-aes-armv4-bsaes-armv7-sha256-armv4-.pl-make-it-work-.patch \
"

