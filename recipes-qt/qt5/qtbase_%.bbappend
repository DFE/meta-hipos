FILESEXTRAPATHS:prepend := "${THISDIR}/qtbase:"

# Append qtbase configuration

PACKAGECONFIG:append:mx6-nxp-bsp = " tslib icu examples sql-sqlite "

SRC_URI:append:imxgpu3d = " \
	file://0015-Add-eglfs-to-IMX-GPU.patch \
"
