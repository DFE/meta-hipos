DESCRIPTION = "hipos Package Groups"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-hipos-qt \
    packagegroup-hipos-qt-examples \
    packagegroup-hipos-gstreamer \
"

RDEPENDS_packagegroup-hipos-qt = "\
    qtbase-plugins \
    qtbase-tools \
    qtdeclarative \
    qtdeclarative-tools \
    qtdeclarative-qmlplugins \
    qtmultimedia \
    qtmultimedia-plugins \
    qtmultimedia-qmlplugins \
    qtsvg \
    qtsvg-plugins \
    qtsensors \
    qtimageformats-plugins \
    qtsystems \
    qtsystems-tools \
    qtsystems-qmlplugins \
    qtscript \
    qt3d \
    qt3d-qmlplugins \
    qtgraphicaleffects-qmlplugins \
    qtconnectivity-qmlplugins \
    qtlocation-plugins \
    qtlocation-qmlplugins \
    qtwebkit \
    qtwebkit-qmlplugins \
"

RDEPENDS_packagegroup-hipos-qt-examples = "\
    cinematicexperience \
    qtsmarthome \
    qt5everywheredemo \
    qtwebkit-examples-examples \
"

RDEPENDS_packagegroup-hipos-gstreamer = "\
    gstreamer \
    gstreamer-dev \
    gst-plugins-base-app \
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
    gst-fluendo-mpegdemux \
    gstreamer1.0-plugins-base-meta \
    gstreamer1.0-plugins-good-meta \
    gstreamer1.0-plugins-bad-meta \
    gstreamer1.0-rtsp-server \
"
