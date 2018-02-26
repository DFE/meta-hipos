# Fix unbuildable dependency. Occured at Yocto rocko for machine congatec-tca5-64
#
# ERROR: Nothing RPROVIDES 'initramfs-module-install'
# NOTE: Runtime target 'initramfs-module-install' is unbuildable, removing...
# Missing or unbuildable dependency chain was: ['initramfs-module-install']
# ERROR: Required build target 'hipos-prodimage' has no buildable providers.
# Missing or unbuildable dependency chain was: ['hipos-prodimage', 'core-image-minimal-initramfs', 'initramfs-module-install']
#
# Use initramfs-framework instead of initramfs-live*
PACKAGE_INSTALL_remove_intel-x86-common = " initramfs-module-install"
