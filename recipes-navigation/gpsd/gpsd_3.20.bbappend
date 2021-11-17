FILESEXTRAPATHS:prepend := "${THISDIR}/gpsd:"

# Without 'LDFLAGS -lm' gpsd compile fails (yocto/morty) with following error:
# | ./libgpsd.so: error: undefined reference to 'atan2'
# | ./libgpsd.so: error: undefined reference to 'pow'
# | ./libgpsd.so: error: undefined reference to 'sqrt'
# | ./libgpsd.so: error: undefined reference to 'sin'
# | ./libgpsd.so: error: undefined reference to 'cos'
# | collect2: error: ld returned 1 exit status
LDFLAGS:prepend = " -lm "

SRC_URI += " \
    file://gpsd.service \
"

# for HydraIP we do not need gpsd.socket unit
do_install:append() {
    rm -f ${D}${systemd_unitdir}/system/${PN}.socket
    rm -f ${D}${systemd_unitdir}/system/gpsdctl@.service

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/${BPN}.service ${D}${systemd_unitdir}/system/${BPN}.service
}
SYSTEMD_SERVICE:${PN} = "${PN}.service"
