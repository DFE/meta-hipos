require hipos-image.inc

PR_append = ".4"

export IMAGE_BASENAME = "imoc-devimage"

IMAGE_FSTYPES = "tar.bz2"

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
  imx-test \
  sntp \
"

# qt5
IMAGE_INSTALL += " \
    qtbase-fonts \
    qtbase-plugins \
    qtbase-tools \
    qtbase-examples \
    qtdeclarative \
    qtdeclarative-plugins \
    qtdeclarative-tools \
    qtdeclarative-examples \
    qtdeclarative-qmlplugins \
    qtmultimedia \
    qtmultimedia-plugins \
    qtmultimedia-examples \
    qtmultimedia-qmlplugins \
    qtsvg \
    qtsvg-plugins \
    qtsensors \
    qtimageformats-plugins \
    qtsystems \
    qtsystems-tools \
    qtsystems-examples \
    qtsystems-qmlplugins \
    qtscript \
    qt3d \
    qt3d-examples \
    qt3d-qmlplugins \
    qt3d-tools \
    qtgraphicaleffects-qmlplugins \
    qtconnectivity-qmlplugins \
    qtlocation-plugins \
    qtlocation-qmlplugins \
    cinematicexperience \
"
# these would require ruby-native:
#    qtwebkit
#    qtwebkit-examples-examples
#    qtwebkit-qmlplugins


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
  opencv \
  opencv-dev \
"

IMAGE_INSTALL_append_himx0280 += " \
  gst-fsl-plugin \
  fsl-alsa-plugins \
"

