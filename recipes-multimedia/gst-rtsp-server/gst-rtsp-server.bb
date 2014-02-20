DESCRIPTION = "gst-rtsp-server Recipe using autotools"
HOMEPAGE = "http://cgit.freedesktop.org/gstreamer/gst-rtsp-server/"
SECTION = "libs/multimedia"
LICENSE = "GPL"

PR = "r0"

DEPENDS = "gstreamer"

SRC_URI = "git://anongit.freedesktop.org/gstreamer/gst-rtsp-server;protocol=git;tag=RELEASE-0.10.8"
S = "${WORKDIR}/git"
 
inherit autotools