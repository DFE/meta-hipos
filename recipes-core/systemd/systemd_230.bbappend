FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
               file://ensure-sysfs-path-before-comparing.patch \
"

