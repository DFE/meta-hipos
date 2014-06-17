# bbapped to meta-openembedded/meta-oe/recipes-connectivity/samba/samba_3.6.8.bb

inherit systemd

PRINC := "${@int(PRINC) + 4}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://samba.service \
                   file://netbios.service "

# systemd
PACKAGES =+ "${PN}-systemd"

FILES_${PN}-systemd += " ${base_libdir}/systemd "

FILES_${PN} += " /usr/lib/pdb \
		 /usr/lib/gpext \
		 /usr/lib/rpc \
		 /usr/lib/idmap \
		 /usr/lib/nss_info \
		 /usr/lib/perfcount "

RDEPENDS_${PN}-systemd += "${PN}"

SYSTEMD_PACKAGES = "${PN}-systemd"

SYSTEMD_SERVICE = "samba.service netbios.service "

do_install_append () {
  install -d ${D}${base_libdir}/systemd/system

  install -m 0644 ${WORKDIR}/samba.service ${D}${base_libdir}/systemd/system/
  install -m 0644 ${WORKDIR}/netbios.service ${D}${base_libdir}/systemd/system/

}


