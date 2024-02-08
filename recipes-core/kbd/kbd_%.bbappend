# Remove console fonts as these are only required for the
# virtual consoles.

FILES:${PN}-consolefonts = ""

do_install:append () {
    rm -fr "${D}${datadir}/consolefonts"
}
