# see http://stackoverflow.com/questions/36221909/why-am-i-getting-thumb-conditional-instruction-should-be-in-it-block-error

EXTRA_OECMAKE_append_arm = " -DCMAKE_CXX_FLAGS_RELEASE="-Wa,-mimplicit-it=thumb" "

# Generate pkgconfig file opencv.pc
# See https://github.com/opencv/opencv/issues/13154
EXTRA_OECMAKE_append = " -DOPENCV_GENERATE_PKGCONFIG=ON -DOPENCV_PC_FILE_NAME=opencv.pc"
