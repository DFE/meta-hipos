require hipos-image.inc

PR_append = ".3"

export IMAGE_BASENAME = "hipos-devimage"

IMAGE_FSTYPES = "tar.bz2"

# SDK
IMAGE_INSTALL += " \
  task-native-sdk \
  gdb \
  gdbserver \
  openssh-sftp-server \
  subversion \
  git \
"

# utils 
IMAGE_INSTALL += " \
  mmc-utils \
"

# multimedia
IMAGE_INSTALL += " \
  gstreamer \
  gst-plugins-base-meta \
  gst-plugins-good-meta \
  gst-plugins-ugly-meta \
  live555 \
  opencv \
  i2c-tools \
"

IMAGE_INSTALL_append_himx += " \
  gst-fsl-plugin \
  fsl-alsa-plugins \
"
