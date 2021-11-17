
do_install:append() {
    TEMP_DATA=$(cat ${D}${sysconfdir}/sysctl.conf | grep -v "kernel.panic");echo "$TEMP_DATA
kernel.panic=30">${D}${sysconfdir}/sysctl.conf
    TEMP_DATA=$(cat ${D}${sysconfdir}/sysctl.conf | grep -v "kernel.panic_on_oops");echo "$TEMP_DATA
kernel.panic_on_oops=1">${D}${sysconfdir}/sysctl.conf
}
