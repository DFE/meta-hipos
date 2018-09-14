# common stuff for all HIPOS images

require image-common.inc

IMAGE_INSTALL_append_himx0294 += " \
  hipos-watchdog \
  hipos-lte-gps \
  libdrtp \
  libdrtp-demo \
"

# http/webdav support
IMAGE_INSTALL += "         \
    lighttpd               \
    lighttpd-module-webdav \
    lighttpd-module-alias  \
"

