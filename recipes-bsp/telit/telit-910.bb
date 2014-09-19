DESCRIPTION = "Telit Modem LE/HE 910 support"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://runmodem.sh;beginline=5;endline=19;md5=885d48456bbe1df46895affa4aae6635"

PR = "r4"

RDEPENDS_${PN} = "udev systemd jq ppp"

SRC_URI = "file://runmodem.sh \
           file://modem-at.service \
           file://modem-ppp.service \
           file://telit-910.rules \
           file://dialup \
           file://dialup-chat-dialin \
           file://dialup-chat-hangup \
"

S = "${WORKDIR}"

inherit systemd

FILES_${PN} = " \
  ${base_libdir}/systemd \
  ${sysconfdir} \
  ${bindir} \
"

CONFFILES_${PN} = " \
  ${sysconfdir}/ppp/peers/dialup \
"

SYSTEMD_SERVICE_${PN} = "modem-at.service modem-ppp.service"

do_install() {
  install -d ${D}${bindir}
  install -m 0755 ${WORKDIR}/runmodem.sh ${D}${bindir}

  install -d ${D}${sysconfdir}/udev/rules.d
  install -m 0644 ${WORKDIR}/telit-910.rules ${D}${sysconfdir}/udev/rules.d/

  install -d ${D}${base_libdir}/systemd/system
  install -m 0644 ${WORKDIR}/modem-at.service ${D}${base_libdir}/systemd/system/
  install -m 0644 ${WORKDIR}/modem-ppp.service ${D}${base_libdir}/systemd/system/

  install -d ${D}${sysconfdir}/ppp/peers/
  install -m 0644 ${WORKDIR}/dialup ${D}${sysconfdir}/ppp/peers/
  install -m 0644 ${WORKDIR}/dialup-chat-dialin ${D}${sysconfdir}/ppp/peers/
  install -m 0644 ${WORKDIR}/dialup-chat-hangup ${D}${sysconfdir}/ppp/peers/
}

