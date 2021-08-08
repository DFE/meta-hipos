OVRDEPENDS += " virtual/libg2d "
# DEPENDS is in yocto pyro necessary
DEPENDS += " virtual/libg2d "

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
"

# This is a workaround until waf is fixed in oe-core
EXTRA_OECONF_append = " --libdir=${libdir}"

