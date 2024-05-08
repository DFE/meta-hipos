# Remove Wayland support from Qt6 toolchain for now
RDEPENDS:${PN}:remove = " \
    nativesdk-qtwayland-dev \
    nativesdk-qtwayland-tools \
"
