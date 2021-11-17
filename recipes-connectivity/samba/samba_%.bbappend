# bbappend to meta-openembedded/meta-oe/recipes-connectivity/samba/samba_???.bb

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://samba.service \
                   file://netbios.service "

# systemd
PACKAGES =+ "${PN}-systemd"

FILES:${PN}-systemd += " ${base_libdir}/systemd "

FILES:${PN} += " /usr/lib/pdb \
		 /usr/lib/gpext \
		 /usr/lib/rpc \
		 /usr/lib/idmap \
		 /usr/lib/nss_info \
		 /usr/lib/perfcount "

RDEPENDS:${PN}-systemd += "${PN}"

SYSTEMD_PACKAGES = "${PN}-systemd"

SYSTEMD_SERVICE = "samba.service netbios.service "

do_install:append () {
  install -d ${D}${base_libdir}/systemd/system

  install -m 0644 ${WORKDIR}/samba.service ${D}${base_libdir}/systemd/system/
  install -m 0644 ${WORKDIR}/netbios.service ${D}${base_libdir}/systemd/system/

}


