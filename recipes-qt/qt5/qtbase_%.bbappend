FILESEXTRAPATHS_prepend := "${THISDIR}/qtbase:"

# Append qtbase configuration

PACKAGECONFIG_append_mx6 = " tslib icu examples sql-sqlite "

SRC_URI_append_imxgpu3d = " \
	file://0015-Add-eglfs-to-IMX-GPU.patch \
"
