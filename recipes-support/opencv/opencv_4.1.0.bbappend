# see http://stackoverflow.com/questions/36221909/why-am-i-getting-thumb-conditional-instruction-should-be-in-it-block-error

EXTRA_OECMAKE_append_arm = " -DCMAKE_CXX_FLAGS_RELEASE="-Wa,-mimplicit-it=thumb" "
