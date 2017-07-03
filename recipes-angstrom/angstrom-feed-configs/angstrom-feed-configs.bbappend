do_compile() {
    mkdir -p ${S}/${sysconfdir}/opkg

    URI="http://package-feed.dresearch-fe.de/hipos/yocto-2.3-pyro"

    echo "src/gz all ${URI}/all" > ${S}/${sysconfdir}/opkg/all-feed.conf
    echo "src/gz ${MACHINE} ${URI}/${MACHINE}" > ${S}/${sysconfdir}/opkg/${MACHINE}-feed.conf

    for feed in ${FEED_ARCHS} ; do
        echo "src/gz ${feed} ${URI}/${feed}" > ${S}/${sysconfdir}/opkg/${feed}-feed.conf
        for suffix in ${MACHINE_SOCARCH_SUFFIX} ; do
            echo "src/gz ${feed}${suffix} ${URI}/${feed}${suffix}" > ${S}/${sysconfdir}/opkg/${feed}${suffix}-feed.conf
        done
    done
}

do_install () {
    install -d ${D}${sysconfdir}/opkg
    install -m 0644  ${S}/${sysconfdir}/opkg/* ${D}${sysconfdir}/opkg/
}


FILES_${PN} = "${sysconfdir}/opkg/*-feed.conf"

CONFFILES_${PN} = "${sysconfdir}/opkg/*-feed.conf"

python populate_packages_prepend () {
    etcdir = bb.data.expand('${sysconfdir}/opkg', d)
}
