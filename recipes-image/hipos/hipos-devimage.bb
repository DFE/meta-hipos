require hipos-image.inc

export IMAGE_BASENAME = "hipos-devimage"

IMAGE_FSTYPES_himx0294 = "tar.bz2"

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
  gstreamer \
  gstreamer-dev \
  gst-plugins-base-app \
  gst-plugins-base-app-dev \
  gst-plugins-base-meta \
  gst-plugins-good-meta \
  gst-plugins-ugly-meta \
  gst-meta-audio \
  gst-meta-video \
  gst-meta-debug \
  gst-plugins-base-tcp \
  gst-plugins-good-meta \
  gst-plugins-good-udp \
  gst-plugins-good-rtp \
  gst-plugins-good-rtpmanager \
  gst-plugins-good-rtsp \
  v4l-utils \
  live555 \
"

# machine specific
IMAGE_INSTALL_append_himx0294 += " \
  packagegroup-hipos-qt-examples \
  packagegroup-hipos-qt     \
  packagegroup-hipos-gstreamer \
"
