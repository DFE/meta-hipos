
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PRINC := "${@int(PRINC) + 3}"

SRC_URI_append_himx0280 =  " file://0001-live555-remove-SO_REUSEPORT.patch \
                       "

