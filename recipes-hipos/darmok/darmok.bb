DESCRIPTION = "Kernel driver for communication with serial attached HIPOS Board Controller"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88"

inherit allarch

PV = "00.11.12"
PR = "r002"

# do not rename this variable because it will be processed by some
# external tooling (see https://dresearchfe.jira.com/browse/HYP-14343)
DRSRCBRANCH="6.10"

SRC_URI = "git://github.com/DFE/darmok.git;branch=${DRSRCBRANCH};protocol=https"
SRCREV = "4f15c0427308d224cef134c9ac5c445ed4c99e25" 

S = "${WORKDIR}/git"

