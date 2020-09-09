
# Avoid error in Yocto dunfell
# gst-libs/gst/gl/gstglphymemory.c:113: undefined reference to `g2d_free' and
# gst-libs/gst/gl/gstglphymemory.c:94: undefined reference to `g2d_alloc'
LDFLAGS_append_mx8 = " -lg2d "
