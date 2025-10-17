// SPDX-License-Identifier: GPL-2.0+
/*
 * Copyright (C) 2016 Freescale Semiconductor, Inc.
 * Copyright (C) 2019 DResearch Fahrzeugelektronik GmbH
 */

#include <asm/arch/clock.h>
#include <asm/arch/iomux.h>
#include <asm/arch/imx-regs.h>
#include <asm/arch/crm_regs.h>
#include <asm/arch/mx6-pins.h>
#include <asm/arch/sys_proto.h>
#include <asm/gpio.h>
#include <asm/mach-imx/iomux-v3.h>
#include <asm/mach-imx/boot_mode.h>
#include <asm/mach-imx/mxc_i2c.h>
#include <asm/io.h>
#include <common.h>
#include <dm/uclass.h>
#include <env.h>
#include <i2c.h>
#include <fsl_esdhc.h>
#include <linux/sizes.h>
#include <linux/delay.h>
#include <mmc.h>

DECLARE_GLOBAL_DATA_PTR;

int dram_init(void)
{
	gd->ram_size = imx_ddr_size();

	return 0;
}

#ifdef CONFIG_FEC_MXC
static int setup_fec(int fec_id)
{
	struct iomuxc *const iomuxc_regs = (struct iomuxc *)IOMUXC_BASE_ADDR;
	int ret;

	if (fec_id == 0) {
		/*
		 * Use 50M anatop loopback REF_CLK1 for ENET1,
		 * clear gpr1[13], set gpr1[17].
		 */
		clrsetbits_le32(&iomuxc_regs->gpr[1], IOMUX_GPR1_FEC1_MASK,
				IOMUX_GPR1_FEC1_CLOCK_MUX1_SEL_MASK);
	} else {
		/*
		 * Use 50M anatop loopback REF_CLK2 for ENET2,
		 * clear gpr1[14], set gpr1[18].
		 */
		clrsetbits_le32(&iomuxc_regs->gpr[1], IOMUX_GPR1_FEC2_MASK,
				IOMUX_GPR1_FEC2_CLOCK_MUX1_SEL_MASK);
	}

	ret = enable_fec_anatop_clock(fec_id, ENET_50MHZ);
	if (ret)
		return ret;

	enable_enet_clk(1);

	return 0;
}
#endif

int board_mmc_get_env_dev(int devno)
{
	return devno;
}

int mmc_map_to_kernel_blk(int devno)
{
	return devno;
}

int board_early_init_f(void)
{
	return 0;
}

static struct udevice* get_i2c_device(int bus, int addr)
{
	struct udevice *idev, *ibus;
	int ret;

	ret = uclass_get_device_by_seq(UCLASS_I2C, bus, &ibus);
	if (ret)
		return 0;

	for (int i = 0; i < 5; ++i) {
		ret = dm_i2c_probe(ibus, addr, 0, &idev);
		if (0 == ret)
			return idev;
	}
	return 0;
}

int board_init(void)
{
	/* Address of boot parameters */
	gd->bd->bi_boot_params = PHYS_SDRAM + 0x100;

	struct udevice *pmic;
	pmic = get_i2c_device(0, 0x08);

	if (pmic) {
		u8 tmp = 0x48;
		/* Reset KSZ8795CLX */
		gpio_request(IMX_GPIO_NR(2, 11), "switch_rst");
		gpio_direction_output(IMX_GPIO_NR(2, 11) , 0);
		dm_i2c_write(pmic, 0x66, &tmp, 1);
		tmp = 0x1f;
		dm_i2c_write(pmic, 0x6d, &tmp, 1);

		mdelay(15);
		gpio_set_value(IMX_GPIO_NR(2, 11), 1);
	} else {
		printf("PMIC on i2c1 not found\n");
	}

#ifdef	CONFIG_FEC_MXC
	setup_fec(CONFIG_FEC_ENET_DEV);
#endif
	return 0;
}

#ifdef CONFIG_CMD_BMODE
static const struct boot_mode board_boot_modes[] = {
	/* 4 bit bus width */
	{"sd1", MAKE_CFGVAL(0x42, 0x20, 0x00, 0x00)},
	{"sd2", MAKE_CFGVAL(0x40, 0x28, 0x00, 0x00)},
	{"qspi1", MAKE_CFGVAL(0x10, 0x00, 0x00, 0x00)},
	{NULL,	 0},
};
#endif

int board_late_init(void)
{
#ifdef CONFIG_CMD_BMODE
	add_board_boot_modes(board_boot_modes);
#endif

#ifdef CONFIG_ENV_VARS_UBOOT_RUNTIME_CONFIG
	env_set("board_name", "himx0294");
	env_set("board_rev", "???");
#endif
	gpio_request(IMX_GPIO_NR(4, 22), "/rev2_detect");
	gpio_direction_input(IMX_GPIO_NR(4, 22));
	if (1 == gpio_get_value(IMX_GPIO_NR(4, 22)) &&
	    !strcmp(env_get("fdt_file"), CONFIG_DEFAULT_FDT_FILE)) {
		char *fdt = HIMX_DEFAULT_FDT_FILE_IMPEC_1;
		printf("Detected IMPEC Rev. 1\n");
		if (env_set("fdt_file", fdt)) {
			printf("env_set: fdt_file '%s' failed\n", fdt);
		}
	}
	return 0;
}

int checkboard(void)
{
	puts("Board: himx0294-impec\n");

	return 0;
}
