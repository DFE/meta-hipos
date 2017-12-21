FILESEXTRAPATHS_prepend := "${THISDIR}/gpsd:"

# Without 'LDFLAGS -lm' gpsd compile fails (yocto/morty) with following error:
# | ./libgpsd.so: error: undefined reference to 'atan2'
# | ./libgpsd.so: error: undefined reference to 'pow'
# | ./libgpsd.so: error: undefined reference to 'sqrt'
# | ./libgpsd.so: error: undefined reference to 'sin'
# | ./libgpsd.so: error: undefined reference to 'cos'
# | collect2: error: ld returned 1 exit status
LDFLAGS_prepend = " -lm "

# for HydraIP we do not need gpsd.socket unit
do_install_append() {
    rm -f ${D}${systemd_unitdir}/system/${PN}.socket
}
SYSTEMD_SERVICE_${PN} = "${PN}.service"

# Add missing link. Needed in yocto/rocko.
# See https://patchwork.openembedded.org/patch/145889/
# Remove next two lines in next yocto release.
ALTERNATIVE_LINK_NAME[gpsd-defaults] = "${sysconfdir}/default/gpsd"
ALTERNATIVE_TARGET[gpsd-defaults] = "${sysconfdir}/default/gpsd.default"

