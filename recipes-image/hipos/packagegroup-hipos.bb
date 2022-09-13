DESCRIPTION = "hipos Package Groups"
LICENSE = "MIT"

# Packages get dynamically renamed
PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup

PACKAGES = "\
    packagegroup-hipos-qt \
    packagegroup-hipos-qt-examples \
    packagegroup-hipos-gstreamer \
"

RDEPENDS:packagegroup-hipos-qt = "\
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
    qtgraphicaleffects-qmlplugins \
    qtconnectivity-qmlplugins \
    qtlocation-plugins \
    qtlocation-qmlplugins \
"

RDEPENDS:packagegroup-hipos-qt-examples = "\
    cinematicexperience \
    qtsmarthome \
    qt5everywheredemo \
"

RDEPENDS:packagegroup-hipos-gstreamer = "\
    gstreamer1.0-plugins-base-meta \
    gstreamer1.0-plugins-good-meta \
    gstreamer1.0-plugins-bad-meta \
    gstreamer1.0-rtsp-server \
"
