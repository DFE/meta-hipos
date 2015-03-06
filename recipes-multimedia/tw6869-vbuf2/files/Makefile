#
# tw6869, Intersil|Twchwell TW6869 video driver with V4L/2 support
#
# Makefile - driver build system
#

EXTRA_CFLAGS += -Idrivers/media/video

#ifeq (${audio}, n)
#tw6869_vbuf2-objs := TW68-core.o TW68-video.o
#else
tw6869_vbuf2-objs := TW68-core.o TW68-video.o TW68-ALSA.o
ccflags-y := -DAUDIO_BUILD
#endif

obj-m := tw6869_vbuf2.o

SRC := $(shell pwd)

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC)

modules_install:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) modules_install

clean:
	rm -f *.o *~ core .depend .*.cmd *.ko *.mod.c
	rm -f Module.markers Module.symvers modules.order
	rm -rf .tmp_versions Modules.symvers

