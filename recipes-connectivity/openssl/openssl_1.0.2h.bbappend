# No architecture check for class-native
#
# ERROR: Can't locate find.pl
#
# Origin: https://lists.openembedded.org/g/openembedded-core/message/23661

FILESEXTRAPATHS_prepend_class-native := "${THISDIR}/files:"

SRC_URI_append_class-native = " \
        file://find.pl \
		file://0001-local-find.patch \
"

do_configure_prepend() {
  cp ${WORKDIR}/find.pl ${S}/util/find.pl
}
