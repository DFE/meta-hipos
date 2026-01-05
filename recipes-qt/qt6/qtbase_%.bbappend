FILESEXTRAPATHS:prepend := "${THISDIR}/qtbase:"

# Append qtbase configuration

PACKAGECONFIG:append:mx6-nxp-bsp = " tslib icu examples sql-sqlite "

SRC_URI:append:imxgpu3d = " \
	file://0015-Add-eglfs-to-IMX-GPU.patch \
"

PACKAGECONFIG_GRAPHICS:remove="gbm"

# With Qt 6.10 Wayland is enabled for i.Mx6. Disable it again.
EXTRA_OECMAKE:append:himx0294 = " -DQT_FEATURE_eglfs_viv_wl=OFF"
