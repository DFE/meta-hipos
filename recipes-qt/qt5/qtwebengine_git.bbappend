# Disable gold-linker for host builds
# In yocto sumo branch qtwebengine 5.10 fails with following error message:
# To avoid error:
# | FAILED: host/brotli
# ...
# | collect2: fatal error: cannot find 'ld'
# | compilation terminated.
FILESEXTRAPATHS_prepend := "${THISDIR}/qtwebengine:"
SRC_URI += " \
	file://disable-gold-linker-for-host-builds.patch \
"

