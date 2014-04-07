PRINC := "${@int(PRINC) + 1}"

RDEPENDS_${PN} += " stat "

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

