DESCRIPTION = "This systemd-service is used to set system time using the rtc on the board controller"
SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = " file://../COPYING;md5=9ac2e7cff1ddaf48b6eab6028f23ef88 "

inherit systemd allarch

RDEPENDS:${PN} = "drbcc gawk bash"

PR = "r16"

SRC_URI = " file://hipos-time.service \
            file://set-time.sh \
            file://COPYING "

FILES:${PN} = "${base_libdir}/systemd \
               ${sysconfdir}/systemd \
               ${sysconfdir}/hipos/set-time.sh "

SYSTEMD_SERVICE:${PN} = "hipos-time.service"

do_install () {
  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/hipos-time.service ${D}${base_libdir}/systemd/system/

  install -d ${D}${sysconfdir}/hipos
  install -m 0755 ${WORKDIR}/set-time.sh ${D}${sysconfdir}/hipos
}
