/*
 * Based on openrd.c:
 * (C) Copyright 2009
 * Net Insight <www.netinsight.net>
 * Written-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
 *
 * Based on sheevaplug.c:
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

#include <common.h>
#include <miiphy.h>
#include <asm/arch/cpu.h>
#include <asm/arch/soc.h>
#include <asm/arch/mpp.h>

#define HIKIRK_OE_LOW		(~(1<<28))        /* RS232 / RS485 */
#define HIKIRK_OE_HIGH		(~(1<<2))         /* SD / UART1 */
#define HIKIRK_OE_VAL_LOW		(0)       /* Sel RS232 */
#define HIKIRK_OE_VAL_HIGH		(1 << 2)  /* Sel SD */

DECLARE_GLOBAL_DATA_PTR;

int board_early_init_f(void)
{
	/*
	 * default gpio configuration
	 * There are maximum 64 gpios controlled through 2 sets of registers
	 * the  below configuration configures mainly initial LED status
	 */
	mvebu_config_gpio(HIKIRK_OE_VAL_LOW,
			HIKIRK_OE_VAL_HIGH,
			HIKIRK_OE_LOW, HIKIRK_OE_HIGH);

	/* Multi-Purpose Pins Functionality configuration */
	static const u32 kwmpp_config[] = {
		MPP0_SPI_SCn,
		MPP1_SPI_MOSI,
		MPP2_SPI_SCK,
		MPP3_SPI_MISO,
		MPP4_UART0_RXD,
		MPP5_UART0_TXD,
		MPP6_SYSRST_OUTn,
		MPP7_GPO,
		MPP8_TW_SDA,
		MPP9_TW_SCK,
		MPP10_GPO,
		MPP11_GPIO,
		MPP12_SD_CLK,
		MPP13_SD_CMD, /* Alt UART1_TXD */
		MPP14_SD_D0,  /* Alt UART1_RXD */
		MPP15_SD_D1,
		MPP16_SD_D2,
		MPP17_SD_D3,
		MPP18_GPO,
		MPP19_GPO,
		MPP20_GE1_0,
		MPP21_GE1_1,
		MPP22_GE1_2,
		MPP23_GE1_3,
		MPP24_GE1_4,
		MPP25_GE1_5,
		MPP26_GE1_6,
		MPP27_GE1_7,
		MPP28_GPIO,
		MPP29_TSMP9,
		MPP30_GE1_10,
		MPP31_GE1_11,
		MPP32_GE1_12,
		MPP33_GE1_13,
		MPP34_GPIO,   /* UART1 / SD sel */
		MPP35_GPIO,
		MPP36_GPIO,
		MPP37_GPIO,
		MPP38_GPIO,
		MPP39_AUDIO_I2SBCLK,
		MPP40_AUDIO_I2SDO,
		MPP41_AUDIO_I2SLRC,
		MPP42_AUDIO_I2SMCLK,
		MPP43_AUDIO_I2SDI,
		MPP44_AUDIO_EXTCLK,
		MPP45_TDM_PCLK,
		MPP46_TDM_FS,
		MPP47_TDM_DRX,
		MPP48_TDM_DTX,
		MPP49_TDM_CH0_RX_QL,
		0
	};

	kirkwood_mpp_conf(kwmpp_config, NULL);
	return 0;
}

int board_init(void)
{
	/*
	 * arch number of board
	 */
	gd->bd->bi_arch_number = MACH_TYPE_HIKIRK;

	/* adress of boot parameters */
	gd->bd->bi_boot_params = mvebu_sdram_bar(0) + 0x100;
	return 0;
}

#ifdef CONFIG_RESET_PHY_R

#define KSZ9031RNX_MMD_CTRL_REG 0xd
#define KSZ9031RNX_MMD_DATA_REG 0xe
/* Configure and enable MV88E1116/88E1121 PHY */
void mv_phy_init(char *name)
{
	u16 reg;
	u16 devadr;

	if (miiphy_set_current_dev(name))
		return;

	/* command to read PHY dev address */
	if (miiphy_read(name, 0xEE, 0xEE, (u16 *) &devadr)) {
		printf("Err..%s could not read PHY dev address\n",
			__FUNCTION__);
		return;
	}

	/*
	 * Enable RGMII delay on rx and tx clock
	 * Ref: sec RGMII Pad Skew Registers of chip datasheet
	 */
	miiphy_write(name, devadr, KSZ9031RNX_MMD_CTRL_REG, 0x2);
	miiphy_write(name, devadr, KSZ9031RNX_MMD_DATA_REG, 0x8);
	miiphy_write(name, devadr, KSZ9031RNX_MMD_CTRL_REG, 0x4002);

	miiphy_read(name,  devadr, KSZ9031RNX_MMD_DATA_REG, &reg);
	miiphy_write(name, devadr, KSZ9031RNX_MMD_DATA_REG, reg | 0x3FF);

	/* reset the phy */
	miiphy_reset(name, devadr);

	printf("KSZ9031RNX Initialized on %s\n", name);
}

void reset_phy(void)
{
	mv_phy_init("egiga0");

	/* configure and initialize both PHY's */
	mv_phy_init("egiga1");
}
#endif /* CONFIG_RESET_PHY_R */
