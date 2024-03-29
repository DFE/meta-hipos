#
# MTD dev package
#

FILES:${PN}-staticdev += "          \
    ${includedir}/mtd/libmtd.h      \
"

do_install:append() {
    # MTD dev package:
    # install libmtd and its headers

    install -d ${D}${includedir}/mtd/
    install -m 0644 ${S}/include/libmtd.h ${D}${includedir}/mtd/
    install -d ${D}${libdir}/
    install -m 0644 ${B}/libmtd.a ${D}${libdir}/
}

