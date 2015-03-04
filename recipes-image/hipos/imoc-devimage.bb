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
  sntp \
  cpuburn-neon \
  htop \
"

# did not work without X11
# imx-test 

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
"

# more (better) qt5 examples
IMAGE_INSTALL += " \
  cinematicexperience \
  qtsmarthome \
  qt5everywheredemo \
"

# Qt5, but these would require ruby-native:
#    qtwebkit
#    qtwebkit-examples-examples
#    qtwebkit-qmlplugins

# gstreamer 0.10
IMAGE_INSTALL += " packagegroup-fsl-gstreamer"
# this did'nt work because gst-plugins-bad compilation failed (wrong SDL lib)
# IMAGE_INSTALL += " packagegroup-fsl-gstreamer-full"

# gstreamer 1.0
# IMAGE_INSTALL += " packagegroup-fslc-gstreamer1.0-commercial"
# IMAGE_INSTALL += " packagegroup-fslc-gstreamer1.0"
# IMAGE_INSTALL += " packagegroup-fslc-gstreamer1.0-full"

# The 1.0 stuff didn't work because it failed to install a wayland sink.
# So, we do it manually:

IMAGE_INSTALL += " \
  gstreamer1.0-plugins-imx \
  gstreamer1.0-plugins-base-meta \
  gstreamer1.0-plugins-good-meta \
  gstreamer1.0-plugins-bad-meta \
"

# more multimedia
IMAGE_INSTALL += " \
  v4l-utils \
  live555 \
  opencv \
  opencv-dev \
"

IMAGE_INSTALL_append_himx0294 += " \
  gpu-viv-bin-mx6q \
  tw6869 \
  tw6869-vbuf2 \
  packagegroup-fsl-gstreamer \
  packagegroup-fslc-gstreamer1.0 \
  gstreamer1.0-plugins-imx \
  gst-fsl-plugin \
  fsl-alsa-plugins \
"

