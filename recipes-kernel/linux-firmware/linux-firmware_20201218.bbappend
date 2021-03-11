FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
PACKAGES =+ " ${PN}-cc2564b \
            "

TI_FWDIR = "/lib/firmware"

SRC_URI_append = " \
		file://TIInit_6.7.16.bts \
  "

FILES_${PN}-cc2564b += " \
  ${TI_FWDIR}/TIInit_6.7.16.bts \
"

ALTERNATIVE_linux-firmware-cc2564b += " TIInit_6.7.16.bts "
ALTERNATIVE_LINK_NAME[TIInit_6.7.16.bts] = "${TI_FWDIR}/TIInit_6.7.16.bts"
ALTERNATIVE_TARGET_linux-firmware-cc2564b[TIInit_6.7.16.bts] = "${TI_FWDIR}/TIInit_6.7.16.bts"

do_install_append () {
  install -d ${D}${TI_FWDIR}/
  install -m 0644 ${WORKDIR}/TIInit_6.7.16.bts ${D}${TI_FWDIR}/
}

