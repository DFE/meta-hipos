# Generate pkgconfig file opencv.pc
# See https://github.com/opencv/opencv/issues/13154
EXTRA_OECMAKE:append = " -DOPENCV_GENERATE_PKGCONFIG=ON -DOPENCV_PC_FILE_NAME=opencv.pc"
