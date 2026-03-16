FITLOADADDR ?= "0x28000000"

FITIMAGE_IMAGES = "kernel fdt ramdisk"

FITIMAGE_LOADADDRESS ?= "0x10008000"
FITIMAGE_ENTRYPOINT  ?= "0x10008000"
FITIMAGE_DTB_LOADADDRESS ?= "0x22000000"

FITIMAGE_IMAGE_kernel ?= "virtual/kernel"
FITIMAGE_IMAGE_kernel[type] ?= "kernel"

FITIMAGE_IMAGE_fdt ?= "virtual/kernel"
FITIMAGE_IMAGE_fdt[type] ?= "fdt"
FITIMAGE_IMAGE_fdt[file] = "\
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-imoc.dtb     \
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-imoc-2.dtb   \
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-ivap.dtb     \
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-dvmon.dtb    \
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-dvmon-2.dtb  \
    ${DEPLOY_DIR_IMAGE}/imx6q-himx0294-dvrec.dtb    \
    ${DEPLOY_DIR_IMAGE}/imx6qp-himx0294-dvrec.dtb   \
"

FITIMAGE_IMAGE_ramdisk[type] ?= "ramdisk"

COMPATIBLE_MACHINE = "himx0294"