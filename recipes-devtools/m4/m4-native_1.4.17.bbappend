# No architecture check for class-native
#
# ERROR: "No supported platform" on newer systems.
#
# Origin: https://web.archive.org/web/20200719012106/http://git.openembedded.org/openembedded-core/plain/meta/recipes-devtools/m4/m4/m4-1.4.18-glibc-change-work-around.patch

FILESEXTRAPATHS_prepend_class-native := "${THISDIR}/files:"

SRC_URI_append_class-native = " \
        file://m4-1.4.17-glibc-change-work-around.patch \
"
