/* SPDX-License-Identifier: GPL-2.0+ */
/*
 * Copyright (C) 2016 Freescale Semiconductor, Inc.
 * Copyright (C) 2019 DResearch Fahrzeugelektronik GmbH
 *
 * Configuration settings for the DFE himx0432 board.
 */
#ifndef __MX6ULLEVK_CONFIG_H
#define __MX6ULLEVK_CONFIG_H


#include <asm/arch/imx-regs.h>
#include <linux/sizes.h>
#include "mx6_common.h"
#include <asm/mach-imx/gpio.h>

#ifdef CONFIG_SECURE_BOOT
#ifndef CONFIG_CSF_SIZE
#define CONFIG_CSF_SIZE 0x4000
#endif
#endif

#define PHYS_SDRAM_SIZE	SZ_512M

/* Size of malloc() pool */
#define CONFIG_SYS_MALLOC_LEN		(16 * SZ_1M)

#define CONFIG_MXC_UART
#define CONFIG_MXC_UART_BASE		UART2_BASE

/* MMC Configs */
#ifdef CONFIG_FSL_USDHC
#define CONFIG_SYS_FSL_ESDHC_ADDR	USDHC2_BASE_ADDR

/* NAND pin conflicts with usdhc2 */
#ifdef CONFIG_SYS_USE_NAND
#define CONFIG_SYS_FSL_USDHC_NUM	1
#else
#define CONFIG_SYS_FSL_USDHC_NUM	2
#endif
#endif

/* I2C configs */
#define CONFIG_SYS_I2C
#ifdef CONFIG_CMD_I2C
#define CONFIG_SYS_I2C_MXC
#define CONFIG_SYS_I2C_MXC_I2C1		/* enable I2C bus 1 */
#define CONFIG_SYS_I2C_MXC_I2C2		/* enable I2C bus 2 */
#define CONFIG_SYS_I2C_SPEED		100000
#endif

#define CONFIG_SYS_MMC_IMG_LOAD_PART	1

#define CONFIG_DEFAULT_FDT_FILE_IMPEC_1 "/boot/imx6ull-himx0294-impec.dtb"

#define CONFIG_EXTRA_ENV_SETTINGS \
        "boot_usb=usb start; setenv boottype usb; setenv bootdev 0; " \
                "setenv bootpart 2; setenv bootroot /dev/sda2; run do_boot\0" \
        "console=ttymxc1\0" \
        "kernel_addr=0x83800000\0" \
        "kernel_file=/boot/zImage\0" \
        "fdt_addr=0x83000000\0" \
        "fdt_file=" CONFIG_DEFAULT_FDT_FILE "\0" \
        "fdt_high=0xffffffff\0" \
        "${kernel_addr} ${ramdisk_addr} ${fdt_addr}\0" \
        "do_boot=run load_kernel; run load_fdt; run setbootargs; " \
                "bootz ${kernel_addr} - ${fdt_addr}\0" \
        "load_fdt=ext4load ${boottype} ${bootdev}:${bootpart} ${fdt_addr} ${fdt_file}\0" \
        "load_kernel=ext4load ${boottype} ${bootdev}:${bootpart} ${kernel_addr} ${kernel_file}\0" \
        "setbootargs=setenv bootargs noinitrd console=ttymxc1,115200 " \
                "root=${bootroot} rootwait\0" \
        "x_bootA=setenv boottype mmc; setenv bootdev 0; setenv bootpart 1; " \
                "setenv bootroot /dev/mmcblk0p1; run do_boot\0" \
        "x_bootB=setenv boottype mmc; setenv bootdev 0; setenv bootpart 2; " \
                "setenv bootroot /dev/mmcblk0p2; run do_boot\0"

/* This boot command stores the environment persistently. This ensures that the "fdt_file"
   variable is set and u-boot and kernel use the same variable. HYP-12761 */
#define CONFIG_BOOTCOMMAND      "setenv bootcmd run x_bootA; saveenv; boot"

/* Miscellaneous configurable options */
#define CONFIG_SYS_MEMTEST_START	0x80000000
#define CONFIG_SYS_MEMTEST_END		(CONFIG_SYS_MEMTEST_START + 0x8000000)

#define CONFIG_SYS_LOAD_ADDR		CONFIG_LOADADDR
#define CONFIG_SYS_HZ			1000

/* Physical Memory Map */
#define PHYS_SDRAM			MMDC0_ARB_BASE_ADDR

#define CONFIG_SYS_SDRAM_BASE		PHYS_SDRAM
#define CONFIG_SYS_INIT_RAM_ADDR	IRAM_BASE_ADDR
#define CONFIG_SYS_INIT_RAM_SIZE	IRAM_SIZE

#define CONFIG_SYS_INIT_SP_OFFSET \
	(CONFIG_SYS_INIT_RAM_SIZE - GENERATED_GBL_DATA_SIZE)
#define CONFIG_SYS_INIT_SP_ADDR \
	(CONFIG_SYS_INIT_RAM_ADDR + CONFIG_SYS_INIT_SP_OFFSET)

/* environment organization */
#define CONFIG_SYS_MMC_ENV_DEV		0	/* USDHC1 */
#define CONFIG_SYS_MMC_ENV_PART		0	/* user area */
#define CONFIG_MMCROOT			"/dev/mmcblk1p2"  /* USDHC2 */

#define CONFIG_IMX_THERMAL

#define CONFIG_IOMUX_LPSR

#define CONFIG_SOFT_SPI

#ifdef CONFIG_FSL_QSPI
#define CONFIG_SYS_FSL_QSPI_AHB
#define CONFIG_SF_DEFAULT_BUS		0
#define CONFIG_SF_DEFAULT_CS		0
#define CONFIG_SF_DEFAULT_SPEED	40000000
#define FSL_QSPI_FLASH_NUM		1
#define FSL_QSPI_FLASH_SIZE		SZ_32M
#endif

#ifdef CONFIG_CMD_NET
#define CONFIG_FEC_MXC
#define CONFIG_FEC_ENET_DEV             0

#define CONFIG_MII
#define IMX_FEC_BASE                    ENET_BASE_ADDR
#define CONFIG_FEC_MXC_PHYADDR          0x1
#define CONFIG_FEC_XCV_TYPE             RMII
#define CONFIG_ETHPRIME                 "eth0"
#define CONFIG_FEC_FIXED_SPEED          100
#endif

#endif
