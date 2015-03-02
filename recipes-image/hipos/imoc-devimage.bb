# this is FBL's working image for himx0294

require hipos-image.inc

PR_append = ".5"

export IMAGE_BASENAME = "imoc-devimage"

IMAGE_FSTYPES = "tar.bz2"

EXTRA_IMAGE_FEATURES += " debug-tweaks package-management"

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
  cpuburn-neon \
  htop \
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
# Qt5, but these would require ruby-native:
#    qtwebkit
#    qtwebkit-examples-examples
#    qtwebkit-qmlplugins

# gstreamer
IMAGE_INSTALL += " packagegroup-fsl-gstreamer"
IMAGE_INSTALL += " packagegroup-fsl-gstreamer-full"
# IMAGE_INSTALL += " packagegroup-fslc-gstreamer1.0-commercial"
# IMAGE_INSTALL += " packagegroup-fslc-gstreamer1.0"
# IMAGE_INSTALL += " packagegroup-fslc-gstreamer1.0-full"

# more multimedia
IMAGE_INSTALL += " \
  tw6869 \
  v4l-utils \
  live555 \
  opencv \
  opencv-dev \
"

IMAGE_INSTALL_append_himx0294 += " \
  gst-fsl-plugin \
  fsl-alsa-plugins \
"

