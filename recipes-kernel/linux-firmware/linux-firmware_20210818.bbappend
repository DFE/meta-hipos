FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
PACKAGES =+ " ${PN}-cc2564b \
            "

TI_FWDIR = "/lib/firmware"

SRC_URI:append = " \
		file://TIInit_6.7.16.bts \
  "

FILES:${PN}-cc2564b += " \
  ${TI_FWDIR}/TIInit_6.7.16.bts \
"

ALTERNATIVE:linux-firmware-cc2564b += " TIInit_6.7.16.bts "
ALTERNATIVE_LINK_NAME[TIInit_6.7.16.bts] = "${TI_FWDIR}/TIInit_6.7.16.bts"
ALTERNATIVE_TARGET:linux-firmware-cc2564b[TIInit_6.7.16.bts] = "${TI_FWDIR}/TIInit_6.7.16.bts"

do_install:append () {
  install -d ${D}${TI_FWDIR}/
  install -m 0644 ${WORKDIR}/TIInit_6.7.16.bts ${D}${TI_FWDIR}/
}

