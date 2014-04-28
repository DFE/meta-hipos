# common stuff for all HIPOS images

require image-common.inc

PR_append = ".2"

IMAGE_INSTALL += " \
  hipos-watchdog \
"

ROOTFS_POSTPROCESS_COMMAND += "\
    echo "tmpfs                /var/cache           tmpfs      defaults              0  1" >> ${IMAGE_ROOTFS}/etc/fstab; \
    echo "tmpfs                /var/run             tmpfs      defaults              0  1" >> ${IMAGE_ROOTFS}/etc/fstab; \
    echo "tmpfs                /var/log             tmpfs      defaults              0  1" >> ${IMAGE_ROOTFS}/etc/fstab; \
    echo "tmpfs                /var/lock            tmpfs      defaults              0  1" >> ${IMAGE_ROOTFS}/etc/fstab; \
    echo "tmpfs                /var/tmp             tmpfs      defaults              0  1" >> ${IMAGE_ROOTFS}/etc/fstab; \
    echo "tmpfs                /var/volatile        tmpfs      defaults              0  1" >> ${IMAGE_ROOTFS}/etc/fstab; "

