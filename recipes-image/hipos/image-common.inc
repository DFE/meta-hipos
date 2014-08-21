# common stuff for all images

require recipes-images/angstrom/systemd-image.bb

PR_append = "+r12"

IMAGE_FEATURES += " package-management "

IMAGE_INSTALL += "          \
  kernel-modules            \
  linux-firmware-ralink     \
  htop                      \
  bash                      \
  libdrbcc                  \
  drbcc                     \
  hipos-device-info         \
  hipos-network-setup       \
  hipos-time                \
  python-netserver          \
  python-subprocess         \
  udev-extraconf            \
"

IMAGE_INSTALL_append_hikirk += "   \
  u-boot-fw-utils           \
"

# profiling
IMAGE_INSTALL += "  \
  systemd-analyze   \
"

# helpers
IMAGE_INSTALL += "  \
  vim               \
  mtd-utils         \
  mc                \
  nano              \
  screen            \
  file              \
"

# system / plumbing level tools
IMAGE_INSTALL += "  \
    ethtool         \
    ltrace          \
    strace          \
    pciutils        \
    tcpdump         \
    iperf           \
    procps          \
"

# smb support
IMAGE_INSTALL += " samba-systemd "

# http/webdav support
IMAGE_INSTALL += "         \
    lighttpd               \
    lighttpd-module-webdav \
    lighttpd-module-alias  \
"

# file system tools
IMAGE_INSTALL += "      \
    e2fsprogs           \
    e2fsprogs-mke2fs    \
    dosfstools          \
    parted              \
    mdadm               \
    hdparm		\
    smartmontools	\
"

