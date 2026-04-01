/* SPDX-License-Identifier: GPL-2.0+ */
/*
 * Copyright 2019 NXP
 */

#ifndef __IMX8MP_EVK_H
#define __IMX8MP_EVK_H

#include <linux/sizes.h>
#include <linux/stringify.h>
#include <asm/arch/imx-regs.h>
#include "imx_env.h"

#define CFG_SYS_UBOOT_BASE	(QSPI0_AMBA_BASE + CONFIG_SYS_MMCSD_RAW_MODE_U_BOOT_SECTOR * 512)

#if defined(CONFIG_CMD_NET)
#define CFG_FEC_MXC_PHYADDR          1

#define PHY_ANEG_TIMEOUT 20000

#endif

#ifdef CONFIG_DISTRO_DEFAULTS
#define BOOT_TARGET_DEVICES(func) \
	func(USB, usb, 0) \
	func(MMC, mmc, 1) \
	func(MMC, mmc, 2)

#include <config_distro_bootcmd.h>
#else
#define BOOTENV
#endif

#define JH_ROOT_DTB    "imx8mp-evk-root.dtb"
/* jh_root_mem: set the memory space used by Jailhouse root cell */
#define JAILHOUSE_ENV \
	"jh_clk= \0 " \
	"jh_root_dtb=" JH_ROOT_DTB "\0" \
	"jh_mmcboot=setenv fdtfile ${jh_root_dtb};" \
		"setenv jh_clk kvm.enable_virt_at_load=false clk_ignore_unused; " \
		"setenv jh_root_mem 0x16000000@0x40000000,0x62000000@0x58000000,0xc0000000@0x100000000; " \
			   "if run loadimage; then " \
				   "run mmcboot; " \
			   "else run jh_netboot; fi; \0" \
	"jh_netboot=setenv fdtfile ${jh_root_dtb}; " \
		"setenv jh_root_mem 0x16000000@0x40000000,0x62000000@0x58000000,0xc0000000@0x100000000; " \
		"setenv jh_clk kvm.enable_virt_at_load=false clk_ignore_unused; run netboot; \0 "

#define SR_IR_V2_COMMAND \
	"nodes=/busfreq /power-domains /soc@0/caam-sm@100000 /soc@0/bus@30000000/caam_secvio /soc@0/bus@30000000/caam-snvs@30370000 /soc@0/bus@30800000/flexspi_nand@30bb0000 /soc@0/bus@32c00000/mipi_dsi@32e60000 /soc@0/bus@32c00000/lcd-controller@32e80000 /soc@0/bus@32c00000/blk-ctl@32ec0000 /soc@0/bus@30800000/i2c@30a20000/pca9450@25 /soc@0/bus@30800000/i2c@30a30000/adv7535@3d /soc@0/bus@30800000/i2c@30a30000/tcpc@50 /wdt-reboot /mcu_rdc /soc@0/bus@30800000/ethernet@30bf0000 /dsi-host /rm67199_panel /cbtl04gp /binman /vpu_g1@38300000 /vpu_g2@38310000 /vpu_vc8000e@38320000 /vpu_v4l2 /gpu3d@38000000 /gpu2d@38008000 /vipsi@38500000 /mix_gpu_ml \0" \
	"sr_ir_v2_cmd=cp.b ${fdtcontroladdr} ${fdt_addr_r} 0x10000;"\
	"fdt addr ${fdt_addr_r};"\
	"fdt set /soc@0/usb@32f10100/usb@38100000 compatible snps,dwc3;" \
	"fdt set /soc@0/usb@32f10108/usb@38200000 compatible snps,dwc3;" \
	"for i in ${nodes}; do fdt rm ${i}; done \0"

#define CFG_MFG_ENV_SETTINGS \
	CFG_MFG_ENV_SETTINGS_DEFAULT \
	"initrd_addr=0x43800000\0" \
	"initrd_high=0xffffffffffffffff\0" \
	"emmc_dev=2\0"\
	"sd_dev=1\0"


#ifdef CONFIG_NAND_BOOT
#define MFG_NAND_PARTITION "mtdparts=gpmi-nand:64m(nandboot),16m(nandfit),64m(nandkernel),16m(nanddtb),8m(nandtee),-(nandrootfs)"
#endif

/* Initial environment variables */
#if defined(CONFIG_NAND_BOOT)
#define CFG_EXTRA_ENV_SETTINGS \
	CFG_MFG_ENV_SETTINGS \
	"splashimage=0x50000000\0" \
	"fdt_addr_r=0x43000000\0"			\
	"fdt_addr=0x43000000\0"			\
	"fdt_high=0xffffffffffffffff\0" \
	"mtdparts=" MFG_NAND_PARTITION "\0" \
	"console=ttymxc1,115200 earlycon=ec_imx6q,0x30890000,115200\0" \
	"bootargs=console=ttymxc1,115200 earlycon=ec_imx6q,0x30890000,115200 ubi.mtd=nandrootfs "  \
		"root=ubi0:nandrootfs rootfstype=ubifs "		     \
		MFG_NAND_PARTITION \
		"\0" \
	"bootcmd=nand read ${loadaddr} 0x5000000 0x4000000;"\
		"nand read ${fdt_addr_r} 0x9000000 0x100000;"\
		"booti ${loadaddr} - ${fdt_addr_r}"

#else
#define CFG_EXTRA_ENV_SETTINGS		\
	CFG_MFG_ENV_SETTINGS \
	BOOTENV \
	"kernel_addr_r=" __stringify(CONFIG_SYS_LOAD_ADDR) "\0" \
	"do_boot=run switch_init; run loadimage; run loadfdt; run setbootargs; booti ${loadaddr} - ${fdt_addr}\0" \
	"image=/boot/Image\0" \
	"fdt_addr_r=0x43000000\0"			\
	"fdt_addr=0x43000000\0"			\
	"fdt_high=0xffffffffffffffff\0"		\
	"fdtfile=/boot/" CONFIG_DEFAULT_FDT_FILE "\0" \
	"switch_init=run switch_reset; run switch_ctrl; run switch_speed_port2\0" \
	"switch_reset=gpio clear 97; sleep 0.1; gpio set 97; sleep 0.1\0" \
	"switch_ctrl=mii device ethernet@30bf0000; mii write 0x15 1 0xc003; mii write 0x16 1 0xcfff\0" \
	"switch_speed_port2=mii write 0x1c 0x19 0x0; mii write 0x1c 0x18 0x9449; sleep 0.1; mii write 0x1c 0x19 0x9140; mii write 0x1c 0x18 0x9440\0" \
	"loadimage=ext4load ${boottype} ${bootdev}:${bootpart} ${loadaddr} ${image}\0" \
	"loadfdt=ext4load ${boottype} ${bootdev}:${bootpart} ${fdt_addr_r} ${fdtfile}\0" \
	"setbootargs=setenv bootargs noinitrd console=ttymxc1,115200 " \
		"root=${bootroot} rootwait\0" \
	"x_bootA=setenv boottype mmc; setenv bootdev 2; setenv bootpart 1; " \
		"setenv bootroot /dev/mmcblk2p1; run do_boot\0" \
	"x_bootB=setenv boottype mmc; setenv bootdev 2; setenv bootpart 2; " \
		"setenv bootroot /dev/mmcblk2p2; run do_boot\0"
#endif

/* Link Definitions */

#define CFG_SYS_INIT_RAM_ADDR	0x40000000
#define CFG_SYS_INIT_RAM_SIZE	0x80000


/* Totally 6GB DDR */
#define CFG_SYS_SDRAM_BASE		0x40000000
#define PHYS_SDRAM			0x40000000
#define PHYS_SDRAM_SIZE			0xC0000000	/* 3 GB */
#define PHYS_SDRAM_2			0x100000000
#ifdef CONFIG_TARGET_IMX8MP_DDR4_EVK
#define PHYS_SDRAM_2_SIZE		0x40000000	/* 1 GB */
#else
#define PHYS_SDRAM_2_SIZE		0x40000000	/* 1 GB */
//#define PHYS_SDRAM_2_SIZE		0xC0000000	/* 3 GB */
#endif

#define CFG_MXC_UART_BASE		UART2_BASE_ADDR

#define CFG_SYS_NAND_BASE           0x20000000

#ifdef CONFIG_TARGET_IMX8MP_DDR4_EVK
#define CFG_SYS_FSL_USDHC_NUM	1
#else
#define CFG_SYS_FSL_USDHC_NUM	2
#endif

#ifdef CONFIG_ANDROID_SUPPORT
#include "imx8mp_evk_android.h"
#endif

#endif
