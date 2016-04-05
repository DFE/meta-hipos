
PROVIDES += "${PN}-plistlib"
PACKAGES += "${PN}-plistlib"

SUMMARY_${PN}-plistlib="Generate and parse Mac OS X .plist files"
RDEPENDS_${PN}-plistlib="${PN}-core ${PN}-datetime ${PN}-io"
FILES_${PN}-plistlib="${libdir}/python2.7/plistlib.* "

RDEPENDS_${PN}-modules += "${PN}-plistlib"

