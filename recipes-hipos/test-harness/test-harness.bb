DESCRIPTION = "Test harness - easy mocking for C unit tests"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = " file://COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

PR = "r2"
PV = "1.0"

inherit autotools

SRCREV="${AUTOREV}"
SRC_URI=" git://github.com/t-lo/test_harness.git;protocol=https;branch=master"
S = "${WORKDIR}/git"

