# common stuff for all HIPOS images

require image-common.inc

IMAGE_INSTALL:append:himx0294 = " \
  hipos-watchdog \
  hipos-lte-gps \
  libdrtp \
  libdrtp-demo \
"

# http/webdav support
IMAGE_INSTALL += "         \
    lighttpd               \
    lighttpd-module-webdav \
"


# Marker file allowing scripts to distinguish secure builds from non-secure builds
ROOTFS_POSTPROCESS_COMMAND:append:hipos-cyber-security = " add_hipos_secure_build_marker; "

add_hipos_secure_build_marker() {
    install -d ${IMAGE_ROOTFS}${sysconfdir}
    echo "SECURE_BUILD=true" > ${IMAGE_ROOTFS}${sysconfdir}/hipos-build-info
}
