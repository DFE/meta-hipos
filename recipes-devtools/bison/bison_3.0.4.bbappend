# No architecture check for class-native
#
# ERROR: Please port gnulib fseterr.c to your platform!
#
# Origin: https://github.com/rdslw/openwrt/blob/e5d47f32131849a69a9267de51a30d6be1f0d0ac/tools/bison/patches/110-glibc-change-work-around.patch

FILESEXTRAPATHS_prepend_class-native := "${THISDIR}/files:"

SRC_URI_append_class-native = " \
        file://110-glibc-change-work-around.patch \
"
