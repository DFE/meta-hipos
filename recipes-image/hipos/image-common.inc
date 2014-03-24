# common stuff for all images

require recipes-images/angstrom/systemd-image.bb

PR_append = "+r6"

IMAGE_FEATURES += " package-management "

IMAGE_INSTALL += "          \
  kernel-modules            \
  htop                      \
  bash                      \
  libdrbcc                  \
  u-boot-fw-utils           \
  hipos-device-info         \
  hipos-network-setup       \
  hipos-time                \
  python-netserver          \
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

# nfs support
IMAGE_INSTALL += "      \
    nfs-utils           \
    nfs-utils-systemd   \
    nfs-utils-client    \
    nfs-utils-doc       \
    nfs-utils-stats     \
    rpcbind             \
    quota               \
    quota-systemd       \
"


#    rpcbind-systemd     \
#

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
    parted              \
    mdadm               \
    hdparm		\
    smartmontools	\
"

