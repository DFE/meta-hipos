/*
 * Based on openrd.h:
 * (C) Copyright 2009
 * Net Insight <www.netinsight.net>
 * Written-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
 *
 * Based on sheevaplug.h:
 * (C) Copyright 2009
 * Marvell Semiconductor <www.marvell.com>
 * Written-by: Prafulla Wadaskar <prafulla@marvell.com>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301 USA
 */

#ifndef _CONFIG_HIKIRK_H
#define _CONFIG_HIKIRK_H

/*
 * Version number information
 */
#define CONFIG_IDENT_STRING	"\nhikirk"

/*
 * High Level Configuration Options (easy to change)
 */
#define CONFIG_SHEEVA_88SV131  1   /* CPU Core subversion */
#define CONFIG_KIRKWOOD        1   /* SOC Family Name */
#define CONFIG_KW88F6281       1   /* SOC Name */
#define CONFIG_MACH_HIKIRK         /* Machine type */
#define CONFIG_SKIP_LOWLEVEL_INIT  /* disable board lowlevel_init */

/*
 * Commands configuration
 */
#define CONFIG_SYS_NO_FLASH		/* Declare no flash (NOR/SPI) */
#define CONFIG_SF_DEFAULT_SPEED  80000000
#define CONFIG_ENV_SPI_MAX_HZ CONFIG_SF_DEFAULT_SPEED 

/*
 * mv-common.h should be defined after CMD configs since it used them
 * to enable certain macros
 */
#include "mv-common.h"

#undef CONFIG_SPI_FLASH_MACRONIX
#define CONFIG_SPI_FLASH_MACRONIX
#define CONFIG_SPI_FLASH_STMICRO
/*
 *  Environment variables configurations
 */
#ifdef CONFIG_CMD_NAND
#define CONFIG_ENV_IS_IN_NAND		1
#define CONFIG_ENV_SECT_SIZE		0x20000	/* 128K */
/*
 * max 4k env size is enough, but in case of nand
 * it has to be rounded to sector size
 */
#define CONFIG_ENV_SIZE			0x20000	/* 128k */
#define CONFIG_ENV_ADDR			0x60000
#define CONFIG_ENV_OFFSET		0x60000	/* env starts here */
#else
#define CONFIG_ENV_IS_IN_SPI_FLASH
#define CONFIG_SYS_REDUNDAND_ENVIRONMENT
#define CONFIG_ENV_OFFSET       	0x1d0000
#define CONFIG_ENV_OFFSET_REDUND	0x1e0000
#define CONFIG_ENV_SIZE         	0x10000
#define CONFIG_ENV_SIZE_REDUND		(CONFIG_ENV_SIZE)
#define CONFIG_ENV_SECT_SIZE    	(CONFIG_ENV_SIZE)
#endif

/*
 * auto boot
 */
#define CONFIG_AUTOBOOT_STOP_STR "."
#define CONFIG_ZERO_BOOTDELAY_CHECK
#undef CONFIG_BOOTDELAY
#define CONFIG_BOOTDELAY 0

/*
 * Default environment variables
 */
#define CONFIG_BOOTCOMMAND		"run x_bootA"

#define CONFIG_EXTRA_ENV_SETTINGS	"boot_usb=usb start;"			\
	"setenv bootargs console=ttyS0,115200 rw root=/dev/sda2 rootwait;"	\
	"ext4load usb 0:2 0x2000000 /boot/uImage; ext4load usb 0:2 0x12000000 /boot/kirkwood-hikirk.dtb; bootm 0x2000000 - 0x12000000\0"			\
	"boot_ide=ide reset; setenv bootargs console=ttyS0,115200 rw root=/dev/sda1 rootwait;"    \
	"ext4load ide 0 0x2000000 /boot/uImage; ext4load ide 0 0x12000000 /boot/kirkwood-hikirk.dtb; bootm 0x2000000 - 0x12000000\0"	\
	"x_bootargsA=console=ttyS0,115200 vmalloc=50M rw root=/dev/mmcblk0p1 rootflags=discard rootwait\0"	\
	"x_bootargsB=console=ttyS0,115200 vmalloc=50M rw root=/dev/mmcblk0p2 rootflags=discard rootwait\0"	\
	"x_kernelA=ext4load mmc 0:1 0x2000000 /boot/uImage\0"	\
	"x_kernelB=ext4load mmc 0:2 0x2000000 /boot/uImage\0"	\
	"x_dtA=ext4load mmc 0:1 0x12000000 /boot/kirkwood-hikirk.dtb\0"	\
	"x_dtB=ext4load mmc 0:2 0x12000000 /boot/kirkwood-hikirk.dtb\0"	\
	"x_bootA=${x_kernelA}; ${x_dtA}; setenv bootargs ${x_bootargsA}; bootm 0x2000000 - 0x12000000\0"	\
	"x_bootB=${x_kernelB}; ${x_dtB}; setenv bootargs ${x_bootargsB}; bootm 0x2000000 - 0x12000000\0"

#define CONFIG_OF_LIBFDT

/*
 * Ethernet Driver configuration
 */
#ifdef CONFIG_CMD_NET
#define CONFIG_MVGBE_PORTS	{1, 1}	/* enable both ports */
#define CONFIG_PHY_BASE_ADR	0x2
#endif /* CONFIG_CMD_NET */

/*
 * SATA Driver configuration
 */
#ifdef CONFIG_MVSATA_IDE
#define CONFIG_SYS_ATA_IDE0_OFFSET	MV_SATA_PORT0_OFFSET
#define CONFIG_SYS_ATA_IDE1_OFFSET	MV_SATA_PORT1_OFFSET
#endif /*CONFIG_MVSATA_IDE*/

#define CONFIG_CMD_MMC
#ifdef CONFIG_CMD_MMC
#define CONFIG_MMC
#define CONFIG_GENERIC_MMC
#define CONFIG_MVEBU_MMC
#define CONFIG_SYS_MMC_BASE KW_SDIO_BASE
#endif /* CONFIG_CMD_MMC */

/*
 * Ext4 Access
 */
#define CONFIG_FS_EXT4
#define CONFIG_CMD_EXT2
#define CONFIG_CMD_EXT4
#define CONFIG_CMD_FS_GENERIC

/*
 * FAT Access
 */
#define CONFIG_CMD_FAT

#endif /* _CONFIG_HIKIRK_H */
