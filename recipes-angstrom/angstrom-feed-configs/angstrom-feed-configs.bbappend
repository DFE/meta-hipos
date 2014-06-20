do_compile() {
    mkdir -p ${S}/${sysconfdir}/opkg

    URI="http://package-feed.dresearch-fe.de/hipos/yocto-1.6-daisy"

    for feed in all ${MACHINE} ${FEED_ARCH} ; do
        echo "src/gz ${feed} ${URI}/${feed}" > ${S}/${sysconfdir}/opkg/${feed}-feed.conf
    done
}

do_install () {
    install -d ${D}${sysconfdir}/opkg
    install -m 0644  ${S}/${sysconfdir}/opkg/* ${D}${sysconfdir}/opkg/
}


FILES_${PN} = "${sysconfdir}/opkg/all-feed.conf \
               ${sysconfdir}/opkg/${FEED_ARCH}-feed.conf \
               ${sysconfdir}/opkg/${MACHINE}-feed.conf \
               "

CONFFILES_${PN} = "${sysconfdir}/opkg/all-feed.conf \
                   ${sysconfdir}/opkg/${FEED_ARCH}-feed.conf \
                   ${sysconfdir}/opkg/${MACHINE}-feed.conf \
                   "


python populate_packages_prepend () {
    etcdir = bb.data.expand('${sysconfdir}/opkg', d)
}
