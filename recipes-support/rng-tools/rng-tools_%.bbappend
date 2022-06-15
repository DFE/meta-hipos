# Remove systemd Wants dependency to systemd-udev-settle.service
# Up to Yocto honister this dependency did not exist. For i.mx6
# machines, the dependency is removed again to speed up the boot
# process.
FILESEXTRAPATHS:prepend:mx6 := "${THISDIR}/imx6:"
