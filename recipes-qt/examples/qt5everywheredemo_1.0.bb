# FBL 2015-03-04: fixing a broken SRCREV

SUMMARY = "Qt5 everywhere demo"
DESCRIPTION = "Quick tour of Qt 5.0, primarily focusing on its graphical capabilities."
HOMEPAGE = "https://qt.gitorious.org/qt-labs"
LICENSE = "LGPLv2.1"
#LIC_FILES_CHKSUM = "file://main.cpp;md5=1187cb795a0f96bce64e63dd1a67dc2b"
LIC_FILES_CHKSUM = "file://main.cpp;md5=a3ecdc1d777da347f1bf35dd9966606f"

DEPENDS = "qtdeclarative qtgraphicaleffects"

#SRCREV = "9a868f96ee63c21ceda890d8dfc9d33f093d1b6d"
SRCREV = "6178748a6ea34df40a8e3c9ce67137e33383bb0e"

SRC_URI = "git://gitorious.org/qt-labs/qt5-everywhere-demo.git"

S = "${WORKDIR}/git/QtDemo"

require recipes-qt/qt5/qt5.inc

do_install() {
    install -d ${D}${datadir}/${P}
    install -m 0755 ${B}/QtDemo ${D}${datadir}/${P}   
    cp -a ${S}/qml ${D}${datadir}/${P}  
}

FILES_${PN}-dbg += "${datadir}/${P}/.debug"
FILES_${PN} += "${datadir}"

RDEPENDS_${PN} = "qtdeclarative-qmlplugins qtgraphicaleffects-qmlplugins"
