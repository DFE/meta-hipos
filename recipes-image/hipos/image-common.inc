# common stuff for all images

require recipes-images/angstrom/systemd-image.bb

PR_append = "+r18"

IMAGE_FEATURES += " package-management "

IMAGE_INSTALL += "          \
  kernel-modules            \
  kernel-devicetree         \
  linux-firmware-ralink     \
  htop                      \
  bash                      \
  hipos-network-setup       \
  python-netserver          \
  python-subprocess         \
  udev-extraconf            \
  connman-client            \
"

IMAGE_INSTALL_append_hikirk += "   \
  u-boot-fw-utils           \
  libdrbcc                  \
  drbcc                     \
  hipos-device-info         \
  hipos-time                \
  telit-910                 \
"

IMAGE_INSTALL_append_himx0294 += "   \
  libdrbcc                  \
  drbcc                     \
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
  minicom           \
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

