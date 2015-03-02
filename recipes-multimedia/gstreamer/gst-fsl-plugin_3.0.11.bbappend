# Copyright (C) 2015 DResearch Fahrzeugelektronik GmbH
# Released under the MIT license (see COPYING.MIT for the terms)

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"
SRC_URI += "file://0001-ipu_csc-UYVY-patch.patch"
