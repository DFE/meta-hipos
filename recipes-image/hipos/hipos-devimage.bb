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
  mmc-utils \
  i2c-tools \
  memtester \
  bonnie++ \
  tiobench \
"

# multimedia
IMAGE_INSTALL += " \
  v4l-utils \
  live555 \
"

# machine specific
IMAGE_INSTALL:append:himx0294 += " \
  packagegroup-hipos-qt-examples \
  packagegroup-hipos-qt     \
  packagegroup-hipos-gstreamer \
"
