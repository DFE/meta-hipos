# common stuff for all HIPOS images

require image-common.inc

PR_append = ".3"

IMAGE_INSTALL_append_hikirk += " \
  hipos-watchdog \
"

