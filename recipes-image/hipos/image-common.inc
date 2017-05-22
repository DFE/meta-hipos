# common stuff for all images

require recipes-images/angstrom/systemd-image.bb

# Image feature debug-tweaks makes an image suitable for development. It adds 'allow-empty-password',
# 'empty-root-password', and 'post-install-logging' to IMAGE_FEATURES.
# meta-angstrom/recipes-images/angstrom/angstrom-image.bb adds also allow-empty-password to IMAGE_FEATURES.
# If 'debug-tweaks' or 'allow-empty-password' is in IMAGE_FEATURES then the rootfs postprocess command
# 'ssh_allow_empty_password' is executed and sets option 'PermitEmptyPasswords yes' in rootfs file
# /etc/ssh/sshd_config. There is an other problem in yocto/morty with openssh which installs and uses the
# configuration file /etc/ssh/sshd_config. See https://bugzilla.mindrot.org/show_bug.cgi?id=2475
# ------------------------------------------------------------------------------------------
# Login fails with "Write failed: Broken pipe" when all three of these settings are enabled:
# PasswordAuthentication=yes
# ChallengeResponseAuthentication=yes
# PermitEmptyPasswords=yes
# ------------------------------------------------------------------------------------------
# To workaround this issue we want to disable 'PermitEmptyPasswords'. Which is not possilbe with openssh
# append since the rootfs postprocess command is executed after ipk installation.
# So we remove 'allow-empty-password' and 'debug-tweaks' from IMAGE_FEATURES here.
IMAGE_FEATURES += " package-management post-install-logging "
IMAGE_FEATURES_remove = " allow-empty-password debug-tweaks "

# remove connman
IMAGE_INSTALL_remove = "connman connman-angstrom-settings connman-plugin-loopback connman-plugin-ethernet connman-plugin-wifi connman-tools connman-client"

IMAGE_INSTALL += "          \
  kernel-modules            \
  kernel-devicetree         \
  linux-firmware-ralink     \
  htop                      \
  bash                      \
  python-netserver          \
  python-subprocess         \
  udev-extraconf            \
  hip-udev-extra-rules      \
  iptables		    \
  bluez5		    \
  openvpn		    \
  ntp ntp-utils     	    \
  ifupdown                  \
  hipos-system-tuning	    \
  hipos-usb-check	    \
  tzdata tzdata-misc tzdata-posix tzdata-right tzdata-africa tzdata-americas tzdata-antarctica tzdata-arctic tzdata-asia tzdata-atlantic tzdata-australia tzdata-europe tzdata-pacific \
"

IMAGE_INSTALL_append_himx0294 += "   \
  u-boot-fw-utils           \
  libdrbcc                  \
  libdrtp                   \
  drbcc                     \
  hipos-device-info         \
  hipos-time                \
  hip-machinfo              \
  hipos-network-setup       \
  hipos-net-check           \
"


IMAGE_INSTALL_append_himx0294 += " \
  tslib \
  tslib-calibrate \
  tslib-tests \
  gstreamer1.0-plugins-imx \
  gstreamer1.0-plugins-base \
  eglinfo-fb \
  fsl-alsa-plugins \
"

IMAGE_INSTALL_append_imx6qsabrelite += " \
  tslib \
  tslib-calibrate \
  tslib-tests \
  packagegroup-hipos-qt \
  packagegroup-hipos-qt-examples \
  packagegroup-hipos-gstreamer \
  gstreamer1.0-plugins-imx \
  eglinfo-fb \
  fsl-alsa-plugins \
"

IMAGE_INSTALL_append_imx6dqscm-1gb-qwks += " \
  gstreamer1.0-plugins-imx \
  gstreamer1.0-plugins-base \
"

# profiling
IMAGE_INSTALL += "  \
  systemd-analyze   \
"

# helpers
IMAGE_INSTALL += "  \
  mtd-utils         \
  mc                \
  nano              \
  screen            \
  file              \
  minicom           \
  ppp		    \
"

# system / plumbing level tools
IMAGE_INSTALL += "  \
    ethtool         \
    bridge-utils    \
    ltrace          \
    strace          \
    pciutils        \
    tcpdump         \
    iperf           \
    iperf3          \
    procps          \
    wireless-tools  \
    init-ifupdown   \
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
