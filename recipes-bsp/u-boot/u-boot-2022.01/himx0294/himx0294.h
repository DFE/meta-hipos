/*
 * Copyright (C) 2010-2011 Freescale Semiconductor, Inc.
 * Copyright (C) 2015 DResearch Fahrzeugelektronik GmbH
 *
 * Configuration settings for the DResearch himx0294 board.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef __CONFIG_H
#define __CONFIG_H

#include "mx6_common.h"

#define CONFIG_MACH_TYPE	3769

#define CONFIG_CMDLINE_TAG
#define CONFIG_SETUP_MEMORY_TAGS
#define CONFIG_INITRD_TAG
#define CONFIG_REVISION_TAG

#define CONFIG_BOARD_LATE_INIT
#define CONFIG_USBD_HS

#define CONFIG_MXC_UART
#define CONFIG_MXC_UART_BASE	       UART2_BASE

#ifdef CONFIG_CMD_SF
#define CONFIG_SF_DEFAULT_BUS  0
#define CONFIG_SF_DEFAULT_CS   0
#endif

/* I2C Configs */
#define CONFIG_I2C_EDID

/* MMC Configs */
#define CONFIG_SYS_FSL_ESDHC_ADDR      0
#define CONFIG_SYS_FSL_USDHC_NUM       2

#define CONFIG_BOUNCE_BUFFER

/*
 * SATA Configs
 */
#ifdef CONFIG_CMD_SATA
#define CONFIG_SYS_SATA_MAX_DEVICE	1
#define CONFIG_DWC_AHSATA_PORT_ID	0
#define CONFIG_DWC_AHSATA_BASE_ADDR	SATA_ARB_BASE_ADDR
#define CONFIG_LBA48
#endif

#define CONFIG_FEC_MXC
#define CONFIG_MII
#define IMX_FEC_BASE			ENET_BASE_ADDR
#define CONFIG_FEC_XCV_TYPE		RGMII
#define CONFIG_ETHPRIME			"FEC"
#define CONFIG_FEC_MXC_PHYADDR		6

/* USB Configs */
#define CONFIG_USB_HOST_ETHER
#define CONFIG_USB_ETHER_ASIX
#define CONFIG_USB_ETHER_MCS7830
#define CONFIG_USB_ETHER_SMSC95XX
#define CONFIG_USB_MAX_CONTROLLER_COUNT 2
#define CONFIG_EHCI_HCD_INIT_AFTER_RESET	/* For OTG port */
#define CONFIG_MXC_USB_PORTSC	(PORT_PTS_UTMI | PORT_PTS_PTW)
#define CONFIG_MXC_USB_FLAGS	0

/* Miscellaneous commands */
#if 0
#define CONFIG_CMD_BMODE
#endif

/* Framebuffer and LCD */
#define CONFIG_VIDEO_IPUV3
#define CONFIG_VIDEO_BMP_RLE8
#define CONFIG_SPLASH_SCREEN
#define CONFIG_BMP_16BPP
#define CONFIG_IMX_HDMI
#define CONFIG_IMX_VIDEO_SKIP

/* allow to overwrite serial and ethaddr */
#define CONFIG_ENV_OVERWRITE
#define CONFIG_CONS_INDEX	       1
#define CONFIG_BAUDRATE			       115200

/* Command definition */
#undef CONFIG_CMD_IMLS

#define CONFIG_PREBOOT                 ""

/* This boot command stores the environment persistently. This ensures that the "fdt_file"
   variable is set and u-boot and kernel use the same variable. HYP-12761 */
#define CONFIG_BOOTCOMMAND	"setenv bootcmd run x_bootA; saveenv; boot"

#if defined(CONFIG_BOARD_IS_HIMX_IMOC)
#define HIMX_DEFAULT_FDT_HIGH "fdt_high=4f539000\0"
#define HIMX_DEFAULT_LINUX_DEV "2"
#elif defined(CONFIG_BOARD_IS_HIMX_IVAP)
#define HIMX_DEFAULT_FDT_FILE_DVREC "/boot/imx6q-himx0294-dvrec.dtb"
#define HIMX_DEFAULT_FDT_FILE_DVREC_P "/boot/imx6qp-himx0294-dvrec.dtb"
#define HIMX_DEFAULT_FDT_HIGH "fdt_high=4f539000\0"
#define HIMX_DEFAULT_LINUX_DEV "2"
#elif defined(CONFIG_BOARD_IS_HIMX_DVMON)
#define HIMX_DEFAULT_FDT_FILE_DVMON_2 "/boot/imx6q-himx0294-dvmon-2.dtb"
#define HIMX_DEFAULT_FDT_HIGH ""
#define HIMX_DEFAULT_LINUX_DEV "2"
#elif defined(CONFIG_BOARD_IS_HIMX_IPCAM)
#define HIMX_DEFAULT_FDT_HIGH ""
#define HIMX_DEFAULT_LINUX_DEV "0"
#else
#define HIMX_DEFAULT_FDT_HIGH "fdt_high=4f539000\0"
#define HIMX_DEFAULT_LINUX_DEV "2"
#endif

#define CONFIG_EXTRA_ENV_SETTINGS \
	"boot_usb=usb start; setenv boottype usb; setenv bootdev 0; " \
		"setenv bootpart 2; setenv bootroot /dev/sda2; run do_boot\0" \
	"console=ttymxc1\0" \
	"kernel_addr=0x12000000\0" \
	"kernel_file=/boot/uImage\0" \
	"fdt_addr=0x22000000\0" \
	"fdt_file=" CONFIG_DEFAULT_FDT_FILE "\0" \
	HIMX_DEFAULT_FDT_HIGH \
	"${kernel_addr} ${ramdisk_addr} ${fdt_addr}\0" \
	"do_boot=run load_kernel; run load_fdt; run setbootargs; " \
		"bootm ${kernel_addr} - ${fdt_addr}\0" \
	"load_fdt=ext4load ${boottype} ${bootdev}:${bootpart} ${fdt_addr} ${fdt_file}\0" \
	"load_kernel=ext4load ${boottype} ${bootdev}:${bootpart} ${kernel_addr} ${kernel_file}\0" \
	"setbootargs=setenv bootargs noinitrd console=ttymxc1,115200 " \
		"root=${bootroot} rootwait " \
		"mxc_hdmi.only_cea=0\0" \
	"x_bootA=setenv boottype mmc; setenv bootdev 0; setenv bootpart 1; " \
		"setenv bootroot /dev/mmcblk" HIMX_DEFAULT_LINUX_DEV "p1; run do_boot\0" \
	"x_bootB=setenv boottype mmc; setenv bootdev 0; setenv bootpart 2; " \
		"setenv bootroot /dev/mmcblk" HIMX_DEFAULT_LINUX_DEV "p2; run do_boot\0"

/* Miscellaneous configurable options */
#undef CONFIG_SYS_PROMPT
#define CONFIG_SYS_PROMPT	       "U-Boot > "
#undef CONFIG_SYS_CBSIZE
#define CONFIG_SYS_CBSIZE	       1024

/* Print Buffer Size */
#define CONFIG_SYS_PBSIZE (CONFIG_SYS_CBSIZE + sizeof(CONFIG_SYS_PROMPT) + 16)
#undef CONFIG_SYS_MAXARGS
#define CONFIG_SYS_MAXARGS	       48
#define CONFIG_SYS_BARGSIZE CONFIG_SYS_CBSIZE

#define CONFIG_SYS_LOAD_ADDR	       0x12000000

/* Physical Memory Map */
#define PHYS_SDRAM		       MMDC0_ARB_BASE_ADDR

#define CONFIG_SYS_SDRAM_BASE	       PHYS_SDRAM
#define CONFIG_SYS_INIT_RAM_ADDR       IRAM_BASE_ADDR
#define CONFIG_SYS_INIT_RAM_SIZE       IRAM_SIZE

#define CONFIG_SYS_INIT_SP_OFFSET \
	(CONFIG_SYS_INIT_RAM_SIZE - GENERATED_GBL_DATA_SIZE)
#define CONFIG_SYS_INIT_SP_ADDR \
	(CONFIG_SYS_INIT_RAM_ADDR + CONFIG_SYS_INIT_SP_OFFSET)

/* FLASH and environment organization */
#if defined(CONFIG_ENV_IS_IN_MMC)
#define CONFIG_SYS_MMC_ENV_DEV		0
#elif defined(CONFIG_ENV_IS_IN_SPI_FLASH)
#define CONFIG_ENV_OFFSET		(768 * 1024)
#define CONFIG_ENV_SECT_SIZE		(8 * 1024)
#define CONFIG_ENV_SPI_BUS		CONFIG_SF_DEFAULT_BUS
#define CONFIG_ENV_SPI_CS		CONFIG_SF_DEFAULT_CS
#define CONFIG_ENV_SPI_MODE		CONFIG_SF_DEFAULT_MODE
#define CONFIG_ENV_SPI_MAX_HZ		CONFIG_SF_DEFAULT_SPEED
#endif

/*
 * PCI express
 */
#ifdef CONFIG_CMD_PCI
#define CONFIG_PCI
#define CONFIG_PCI_PNP
#define CONFIG_PCI_SCAN_SHOW
#define CONFIG_PCIE_IMX
#endif

#endif	       /* __CONFIG_H */
