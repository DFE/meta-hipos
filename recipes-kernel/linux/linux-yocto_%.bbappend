
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:hinat = " \
	file://defconfig \
	file://0001-UART-driver-Add-device-driver-for-Altera-MAX10-CPLD-.patch \
	file://0002-SMBus-driver-handle-SMBus-transactions-with-polling-.patch \
	file://0003-Watchdog-driver-Update-the-prescaler-calculation.patch \
	file://0004-Update-CPLD-I2C-Bus-maximum-frequency.patch \
	file://0005-Merge-ptn3460-support-updated-for-linux-4.4.3.patch \
	file://0006-misc-kt_bootcounter-add-a-boot-counter-driver-for-Ko.patch \
	file://0001-Deaktivate-UART0-on-Kontron-boards-HYP-20539.patch \
	file://0001-Deactivate-HOST_RUNNING-GPO-HYP-20539.patch \
"

# Copy kernel configuration
# As the linux-yocto_%.bb recipe is extended, the kernel metadata mechanism,
# which configures the kernel form a git repository, is also applied.
# This leads to a overwriting of kernel configuration values from defconfig.
# To avoid these changes, the defconfig, which is a full kernel configuration,
# is copied after the do_kernel_configme step.
do_configure:prepend:hinat() {
        cp ${WORKDIR}/defconfig ${B}/.config
}
