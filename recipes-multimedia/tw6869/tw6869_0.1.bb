# source code from sensoray website sdk_812_linux_1.1.0.zip downloaded 2014-12
# needs CONFIG

SUMMARY = "tw6869 Linux kernel module"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://TW68-video.c;beginline=1;endline=15;md5=d464c597a9c299dabc3b810fcc9aab90"

inherit module

PR = "r0"
PV = "1.1.0"

SRC_URI = "\
  file://Makefile \
  file://README.txt \
  file://TW68.h \
  file://TW68_defines.h \
  file://s812ioctl.h \
  file://TW68-core.c \
  file://TW68-video.c \
  file://TW68-ALSA.c \
"

S = "${WORKDIR}"

# The inherit of module.bbclass will automatically name module packages with
# "kernel-module-" prefix as required by the oe-core build environment.
