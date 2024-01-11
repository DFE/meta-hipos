# No architecture check for class-native
#
# ERROR: '__elf64_msize' specifies less restrictive attribute than its target 'elf64_fsize': 'const'
#
# Origin: https://elfutils-devel.fedorahosted.narkive.com/VswNALfA/bug-libelf-23884-new-error-elf32-msize-specifies-less-restrictive-attribute-than-its-target-elf32

FILESEXTRAPATHS_prepend_class-native := "${THISDIR}/files:"

SRC_URI_append_class-native = " \
        file://0001-msize-const.patch \
"
