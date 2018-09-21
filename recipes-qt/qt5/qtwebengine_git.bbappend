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

# With yocto sumo branch qtwebengine 5.10 fails when loading a web page:
# 1536818823.313620: [DISP.DrUnit:00000000:T] WEB: Set start page: 'http://www.w3c.de'
# 1536818823.323726: [DISP.DrUnit:00000000:T] WEB: Page is loading: 'http://www.w3c.de/'
# Received signal 7 BUS_ADRALN 000072e0a261
# #0 0x00007392f8ea <unknown>
# #1 0x00007392f766 <unknown>
# #2 0x000072d89e08 <unknown>
# #3 0x00007392fb62 <unknown>
# #4 0x000075f59ef0 <unknown>
# [end of stack trace]
# Calling _exit(1). Core file will not be generated.
# This problem was reported on openembedded-devel mailing list:
# http://lists.openembedded.org/pipermail/openembedded-devel/2018-March/117245.html
#
# For corrective action thumb instruction set is disabled HYP-19186
ARM_INSTRUCTION_SET_armv7a = "arm"
ARM_INSTRUCTION_SET_armv7r = "arm"
ARM_INSTRUCTION_SET_armv7ve = "arm"

