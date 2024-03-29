require hipos-image.inc

export IMAGE_BASENAME = "hipos-devimage"

IMAGE_FSTYPES:himx0294 = "tar.bz2"

# SDK
IMAGE_INSTALL += " \
  packagegroup-sdk-target \
  gdb \
  gdbserver \
  openssh-sftp-server \
  subversion \
  git \
  cmake \
"

# utils 
IMAGE_INSTALL += " \
  bluez5 \
  ltrace \
  mc \
  mmc-utils \
  mtd-utils \
  nano \
  i2c-tools \
  memtester \
  mdadm \
  bonnie++ \
  screen \
  strace \
  tiobench \
"

# multimedia
IMAGE_INSTALL += " \
  v4l-utils \
  live555-examples \
"

# machine specific
IMAGE_INSTALL:append:himx0294 = " \
  packagegroup-hipos-qt-examples \
  packagegroup-hipos-qt     \
  packagegroup-hipos-gstreamer \
"
