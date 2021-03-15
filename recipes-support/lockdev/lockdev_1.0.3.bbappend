
# Add missing liblockdev.so.1 soft link. Needed in gatesgarth.
do_install_append () {
	ln -s liblockdev.so.1.0.3 ${D}${libdir}/liblockdev.so.1
}
