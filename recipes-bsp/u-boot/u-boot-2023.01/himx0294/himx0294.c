/*
 * Copyright (C) 2010-2013 Freescale Semiconductor, Inc.
 * Copyright (C) 2013, Boundary Devices <info@boundarydevices.com>
 * Copyright (C) 2015 DResearch Fahrzeugelektronik GmbH
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/imx-regs.h>
#include <asm/arch/iomux.h>
#include <asm/arch/sys_proto.h>
#include <malloc.h>
#include <asm/arch/mx6-pins.h>
#include <errno.h>
#include <asm/gpio.h>
#include <asm/mach-imx/iomux-v3.h>
#include <asm/mach-imx/mxc_i2c.h>
#include <asm/mach-imx/sata.h>
#include <asm/mach-imx/spi.h>
#include <asm/mach-imx/boot_mode.h>
#include <asm/mach-imx/video.h>
#include <mmc.h>
#include <fsl_esdhc_imx.h>
#include <micrel.h>
#include <miiphy.h>
#include <netdev.h>
#include <asm/arch/crm_regs.h>
#include <asm/arch/mxc_hdmi.h>
#include <i2c.h>
#include <input.h>
#include <netdev.h>
#include <usb/ehci-ci.h>
#include <linux/delay.h>

DECLARE_GLOBAL_DATA_PTR;

#define UART_PAD_CTRL  (PAD_CTL_PUS_100K_UP |			\
	PAD_CTL_SPEED_MED | PAD_CTL_DSE_40ohm |			\
	PAD_CTL_SRE_FAST  | PAD_CTL_HYS)

#define USDHC_PAD_CTRL (PAD_CTL_PUS_47K_UP |			\
	PAD_CTL_SPEED_LOW | PAD_CTL_DSE_80ohm |			\
	PAD_CTL_SRE_FAST  | PAD_CTL_HYS)

#define ENET_PAD_CTRL  (PAD_CTL_PUS_100K_UP |			\
	PAD_CTL_SPEED_MED | PAD_CTL_DSE_40ohm | PAD_CTL_HYS)

#define SPI_PAD_CTRL (PAD_CTL_HYS | PAD_CTL_SPEED_MED |		\
	PAD_CTL_DSE_40ohm     | PAD_CTL_SRE_FAST)

#define BUTTON_PAD_CTRL (PAD_CTL_PUS_100K_UP |			\
	PAD_CTL_SPEED_MED | PAD_CTL_DSE_40ohm | PAD_CTL_HYS)

#define I2C_PAD_CTRL	(PAD_CTL_PUS_100K_UP |			\
	PAD_CTL_SPEED_MED | PAD_CTL_DSE_40ohm | PAD_CTL_HYS |	\
	PAD_CTL_ODE | PAD_CTL_SRE_FAST)

#define WEAK_PULLUP	(PAD_CTL_PUS_100K_UP |			\
	PAD_CTL_SPEED_MED | PAD_CTL_DSE_40ohm | PAD_CTL_HYS |	\
	PAD_CTL_SRE_SLOW)

#define WEAK_PULLDOWN	(PAD_CTL_PUS_100K_DOWN |		\
	PAD_CTL_SPEED_MED | PAD_CTL_DSE_40ohm |			\
	PAD_CTL_HYS | PAD_CTL_SRE_SLOW)

#define OUTPUT_40OHM (PAD_CTL_SPEED_MED|PAD_CTL_DSE_40ohm)

int dram_init(void)
{
#if defined(CONFIG_BOARD_IS_HIMX_IPCAM)
	gd->ram_size = ((ulong)CONFIG_DDR_MB * 1024 * 1024);
#else
	gd->ram_size = imx_ddr_size();
#endif

	return 0;
}

static iomux_v3_cfg_t const uart1_pads[] = {
	MX6_PAD_SD3_DAT6__UART1_RX_DATA | MUX_PAD_CTRL(UART_PAD_CTRL),
	MX6_PAD_SD3_DAT7__UART1_TX_DATA | MUX_PAD_CTRL(UART_PAD_CTRL),
};

static iomux_v3_cfg_t const uart2_pads[] = {
	MX6_PAD_EIM_D26__UART2_TX_DATA | MUX_PAD_CTRL(UART_PAD_CTRL),
	MX6_PAD_EIM_D27__UART2_RX_DATA | MUX_PAD_CTRL(UART_PAD_CTRL),
};

#define PC MUX_PAD_CTRL(I2C_PAD_CTRL)

/* I2C1 */
static struct i2c_pads_info i2c_pad_info0 = {
	.scl = {
		.i2c_mode = MX6_PAD_EIM_D21__I2C1_SCL | PC,
		.gpio_mode = MX6_PAD_EIM_D21__GPIO3_IO21 | PC,
		.gp = IMX_GPIO_NR(3, 21)
	},
	.sda = {
		.i2c_mode = MX6_PAD_EIM_D28__I2C1_SDA | PC,
		.gpio_mode = MX6_PAD_EIM_D28__GPIO3_IO28 | PC,
		.gp = IMX_GPIO_NR(3, 28)
	}
};

/* I2C2 */
static struct i2c_pads_info i2c_pad_info1 = {
	.scl = {
		.i2c_mode = MX6_PAD_KEY_COL3__I2C2_SCL | PC,
		.gpio_mode = MX6_PAD_KEY_COL3__GPIO4_IO12 | PC,
		.gp = IMX_GPIO_NR(4, 12)
	},
	.sda = {
		.i2c_mode = MX6_PAD_KEY_ROW3__I2C2_SDA | PC,
		.gpio_mode = MX6_PAD_KEY_ROW3__GPIO4_IO13 | PC,
		.gp = IMX_GPIO_NR(4, 13)
	}
};

/* I2C3 */
static struct i2c_pads_info i2c_pad_info2 = {
	.scl = {
		.i2c_mode = MX6_PAD_GPIO_5__I2C3_SCL | PC,
		.gpio_mode = MX6_PAD_GPIO_5__GPIO1_IO05 | PC,
		.gp = IMX_GPIO_NR(1, 5)
	},
	.sda = {
		.i2c_mode = MX6_PAD_GPIO_6__I2C3_SDA | PC,
		.gpio_mode = MX6_PAD_GPIO_6__GPIO1_IO06 | PC,
		.gp = IMX_GPIO_NR(1, 6)
	}
};

#if defined(CONFIG_BOARD_IS_HIMX_IPCAM)
static iomux_v3_cfg_t const usdhc1_pads[] = {
	MX6_PAD_SD1_CLK__SD1_CLK   | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD1_CMD__SD1_CMD   | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD1_DAT0__SD1_DATA0 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD1_DAT1__SD1_DATA1 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD1_DAT2__SD1_DATA2 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD1_DAT3__SD1_DATA3 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_GPIO_3__GPIO1_IO03    | MUX_PAD_CTRL(NO_PAD_CTRL), /* CD */
};
#else
static iomux_v3_cfg_t const usdhc3_pads[] = {
	MX6_PAD_SD3_CLK__SD3_CLK   | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD3_CMD__SD3_CMD   | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD3_DAT0__SD3_DATA0 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD3_DAT1__SD3_DATA1 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD3_DAT2__SD3_DATA2 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD3_DAT3__SD3_DATA3 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD3_DAT5__GPIO7_IO00    | MUX_PAD_CTRL(NO_PAD_CTRL), /* CD */
};

static iomux_v3_cfg_t const usdhc4_pads[] = {
	MX6_PAD_SD4_CLK__SD4_CLK   | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD4_CMD__SD4_CMD   | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD4_DAT0__SD4_DATA0 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD4_DAT1__SD4_DATA1 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD4_DAT2__SD4_DATA2 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_SD4_DAT3__SD4_DATA3 | MUX_PAD_CTRL(USDHC_PAD_CTRL),
	MX6_PAD_NANDF_D6__GPIO2_IO06    | MUX_PAD_CTRL(NO_PAD_CTRL), /* CD */
};
#endif

static iomux_v3_cfg_t const enet_pads1[] = {
	MX6_PAD_ENET_MDIO__ENET_MDIO		| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_ENET_MDC__ENET_MDC		| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_TXC__RGMII_TXC	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_TD0__RGMII_TD0	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_TD1__RGMII_TD1	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_TD2__RGMII_TD2	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_TD3__RGMII_TD3	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_TX_CTL__RGMII_TX_CTL	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_ENET_REF_CLK__ENET_TX_CLK	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_RXC__RGMII_RXC	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_RD0__RGMII_RD0	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_RD1__RGMII_RD1	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_RD2__RGMII_RD2	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_RD3__RGMII_RD3	| MUX_PAD_CTRL(ENET_PAD_CTRL),
	MX6_PAD_RGMII_RX_CTL__RGMII_RX_CTL	| MUX_PAD_CTRL(ENET_PAD_CTRL),
};

#if defined(CONFIG_BOARD_IS_HIMX_DVMON)
static iomux_v3_cfg_t const misc_pads[] = {
	MX6_PAD_GPIO_0__GPIO1_IO00 		| MUX_PAD_CTRL(NO_PAD_CTRL),
	MX6_PAD_GPIO_1__USB_OTG_ID		| MUX_PAD_CTRL(WEAK_PULLUP),
	NEW_PAD_CTRL(MX6_PAD_GPIO_3__XTALOSC_REF_CLK_24M, PAD_CTL_DSE_48ohm|PAD_CTL_SPEED_LOW),
	MX6_PAD_EIM_D31__GPIO3_IO31		| MUX_PAD_CTRL(NO_PAD_CTRL),
};
#else
static iomux_v3_cfg_t const misc_pads[] = {
	MX6_PAD_GPIO_1__USB_OTG_ID		| MUX_PAD_CTRL(WEAK_PULLUP),
	MX6_PAD_KEY_COL4__USB_OTG_OC		| MUX_PAD_CTRL(WEAK_PULLUP),
	MX6_PAD_ENET_RX_ER__GPIO1_IO24		| MUX_PAD_CTRL(WEAK_PULLUP),
#define ENET_RX_ER_GP IMX_GPIO_NR(1, 24)
};
#endif

#if !defined(CONFIG_BOARD_IS_HIMX_IPCAM)
static void setup_iomux_enet(void)
{
	imx_iomux_v3_setup_multiple_pads(enet_pads1, ARRAY_SIZE(enet_pads1));

	udelay(100);	/* Wait 100 us before using mii interface */
}
#endif

#if defined(CONFIG_BOARD_IS_HIMX_DVMON)
static iomux_v3_cfg_t const usb_pads[] = {
	MX6_PAD_EIM_D31__GPIO3_IO31 | MUX_PAD_CTRL(NO_PAD_CTRL),
};
#else
static iomux_v3_cfg_t const usb_pads[] = {
	NEW_PAD_CTRL(MX6_PAD_GPIO_3__XTALOSC_REF_CLK_24M, PAD_CTL_DSE_48ohm|PAD_CTL_SPEED_LOW),
	MX6_PAD_GPIO_4__GPIO1_IO04 | MUX_PAD_CTRL(NO_PAD_CTRL),
	MX6_PAD_KEY_ROW4__GPIO4_IO15 | MUX_PAD_CTRL(NO_PAD_CTRL),
};
#endif

static void setup_iomux_uart(void)
{
	imx_iomux_v3_setup_multiple_pads(uart1_pads, ARRAY_SIZE(uart1_pads));
	imx_iomux_v3_setup_multiple_pads(uart2_pads, ARRAY_SIZE(uart2_pads));
}

#ifdef CONFIG_USB_EHCI_MX6
int board_ehci_hcd_init(int port)
{
	printf("USB init\n");
	imx_iomux_v3_setup_multiple_pads(usb_pads, ARRAY_SIZE(usb_pads));
#if defined(CONFIG_BOARD_IS_HIMX_DVMON)
	gpio_direction_output(IMX_GPIO_NR(3, 31), 1);
#else
	gpio_direction_output(IMX_GPIO_NR(4, 15), 1);
	/* Reset USB hub */
	gpio_direction_output(IMX_GPIO_NR(1, 4), 0);
	mdelay(2);
	gpio_set_value(IMX_GPIO_NR(1, 4), 1);
#endif

	return 0;
}

int board_ehci_power(int port, int on)
{
	return 0;
}

#endif

static struct fsl_esdhc_cfg usdhc_cfg[2] = {
	{USDHC3_BASE_ADDR},
	{USDHC4_BASE_ADDR},
};

int board_mmc_getcd(struct mmc *mmc)
{
	struct fsl_esdhc_cfg *cfg = (struct fsl_esdhc_cfg *)mmc->priv;
	int gp_cd;

	switch(cfg->esdhc_base) {
	case USDHC1_BASE_ADDR: gp_cd = IMX_GPIO_NR(1, 3); break;
	case USDHC3_BASE_ADDR: gp_cd = IMX_GPIO_NR(7, 0); break;
	default: gp_cd = IMX_GPIO_NR(2, 6); break;
	}

	gpio_direction_input(gp_cd);
	return !gpio_get_value(gp_cd);
}

int board_mmc_init(struct bd_info *bis)
{
	s32 status = 0;
	u32 index = 0;
#if defined(CONFIG_BOARD_IS_HIMX_IPCAM)
	usdhc_cfg[0].esdhc_base = USDHC1_BASE_ADDR;
	usdhc_cfg[0].sdhc_clk = mxc_get_clock(MXC_ESDHC_CLK);
	usdhc_cfg[0].max_bus_width = 4;
	imx_iomux_v3_setup_multiple_pads(
				usdhc1_pads, ARRAY_SIZE(usdhc1_pads));
	status = fsl_esdhc_initialize(bis, &usdhc_cfg[index]);
#else

	usdhc_cfg[0].sdhc_clk = mxc_get_clock(MXC_ESDHC3_CLK);
	usdhc_cfg[1].sdhc_clk = mxc_get_clock(MXC_ESDHC4_CLK);

	usdhc_cfg[0].max_bus_width = 4;
	usdhc_cfg[1].max_bus_width = 4;

	for (index = 0; index < 2; ++index) {
		switch (index) {
		case 0:
			imx_iomux_v3_setup_multiple_pads(
				usdhc3_pads, ARRAY_SIZE(usdhc3_pads));
			break;
		case 1:
		       imx_iomux_v3_setup_multiple_pads(
			       usdhc4_pads, ARRAY_SIZE(usdhc4_pads));
		       break;
		default:
		       printf("Warning: you configured more USDHC controllers"
			       "(%d) then supported by the board (%d)\n",
			       index + 1, 2);
		       return status;
		}

		status |= fsl_esdhc_initialize(bis, &usdhc_cfg[index]);
	}

#endif // else defined(CONFIG_BOARD_IS_HIMX_IPCAM)
	return status;
}

#ifdef CONFIG_MXC_SPI
int board_spi_cs_gpio(unsigned bus, unsigned cs)
{
	return (bus == 0 && cs == 0) ? (IMX_GPIO_NR(3, 19)) : -1;
}

static iomux_v3_cfg_t const ecspi1_pads[] = {
	/* SS1 */
	MX6_PAD_EIM_D19__GPIO3_IO19  | MUX_PAD_CTRL(NO_PAD_CTRL),
	MX6_PAD_EIM_D17__ECSPI1_MISO | MUX_PAD_CTRL(SPI_PAD_CTRL),
	MX6_PAD_EIM_D18__ECSPI1_MOSI | MUX_PAD_CTRL(SPI_PAD_CTRL),
	MX6_PAD_EIM_D16__ECSPI1_SCLK | MUX_PAD_CTRL(SPI_PAD_CTRL),
};

static void setup_spi(void)
{
	imx_iomux_v3_setup_multiple_pads(ecspi1_pads,
					 ARRAY_SIZE(ecspi1_pads));
}
#endif

#if defined(CONFIG_BOARD_IS_HIMX_IMOC) || \
	defined(CONFIG_BOARD_IS_HIMX_IVAP)

#define SMI_PHY_COMMAND_REGISTER 0x18
#define SMI_PHY_DATA_REGISTER    0x19
#define MARVELL_GLOBAL2_ADDR 0x1C
#define SMI_BUSY_BIT 15
#define PHY_SPEED_1000 0xe00
#define PHY_SPEED_100  0x0
/*
 * Reads a Marvell register from the MII Management serial interface
 */
static unsigned short marvell_phy_read(int phyaddr, int phyreg)
{
	const char* devname = miiphy_get_current_dev();
	unsigned short val;
	int cmd = 0x9800;
	cmd |= ((phyaddr & 0x1F) << 5);
	cmd |= (phyreg & 0x1F);
	miiphy_write(devname, MARVELL_GLOBAL2_ADDR, SMI_PHY_COMMAND_REGISTER, cmd);

	for (;;) {
		miiphy_read(devname, MARVELL_GLOBAL2_ADDR, SMI_PHY_COMMAND_REGISTER, &val);
		if (!(val & (1 << SMI_BUSY_BIT))) {
			break;
		}
	}
	miiphy_read(devname, MARVELL_GLOBAL2_ADDR, SMI_PHY_DATA_REGISTER, &val);
	return val;
}

/*
 * Writes a Marvell register to the MII Management serial interface
 */
static void marvell_phy_write(int phyaddr, int phyreg, int phydata)
{
	const char* devname = miiphy_get_current_dev();
	int cmd = 0x9400;
	cmd |= ((phyaddr & 0x1F) << 5);
	cmd |= (phyreg & 0x1F);

	miiphy_write(devname, MARVELL_GLOBAL2_ADDR, SMI_PHY_DATA_REGISTER, phydata);
	miiphy_write(devname, MARVELL_GLOBAL2_ADDR, SMI_PHY_COMMAND_REGISTER, cmd);
	for (;;) {
		unsigned short val;
		miiphy_read(devname, MARVELL_GLOBAL2_ADDR, SMI_PHY_COMMAND_REGISTER, &val);
		if (!(val & (1 << SMI_BUSY_BIT))) {
			break;
		}
	}
}

static void set_phy_speed(int phyaddr, int phydata)
{
	marvell_phy_write(phyaddr, MII_CTRL1000, phydata);

	// On port 6 is a real external phy. No reset
	if(6 == phyaddr) { return; }

	// reset to take effect
	int ctrl = marvell_phy_read(phyaddr, MII_BMCR);
	marvell_phy_write(phyaddr, MII_BMCR, ctrl|BMCR_RESET);
	while (marvell_phy_read(phyaddr, MII_BMCR) & BMCR_RESET) {
		udelay(250000);
		printf(".");
	}
}

static void phy_speed(void)
{
	int i;
	char *lanspeed = env_get("lanspeed");

#if defined(CONFIG_BOARD_IS_HIMX_IMOC)
	for(i=0; i<2; ++i) {
		if(lanspeed && strlen(lanspeed)>i && lanspeed[i]=='g') {
			set_phy_speed(i, PHY_SPEED_1000);
		} else {
			set_phy_speed(i, PHY_SPEED_100);
		}
	}
#elif defined(CONFIG_BOARD_IS_HIMX_IVAP)
	for(i=0; i<6; ++i) {
		int port;
		switch (i) {
		case 3: port = 4; break;
		case 4: port = 3; break;
		case 5: port = 6; break;
		default: port = i; break;
		}
		if(lanspeed && strlen(lanspeed)>i && lanspeed[i]=='g') {
			set_phy_speed(port, PHY_SPEED_1000);
		} else {
			set_phy_speed(port, PHY_SPEED_100);
		}
	}
#endif
}

int board_phy_config(struct phy_device *phydev)
{
#if defined(CONFIG_BOARD_IS_HIMX_IMOC) || \
	defined(CONFIG_BOARD_IS_HIMX_IVAP)
	unsigned short val;
	const char* devname = miiphy_get_current_dev();

	miiphy_read(devname, 0x10, 0x3, &val);
	if (((val & 0xFFF0) == 0x1760) || ((val & 0xFFF0) == 0x1720) || ((val & 0xfff0) == 0x3520)) {
		printf("Marvell Switch 0x176/0x172/0x352 detected\n");

		phy_speed();

		/* Enable Tx and Rx RGMII delay on CPU port. */
		/* Enable Forced Flow Control on CPU port. */
		miiphy_read(devname, 0x15, 0x1, &val);
		val |= 0xC0C0;
		miiphy_write(devname, 0x15, 0x1, val);

#if defined(CONFIG_BOARD_IS_HIMX_IVAP)
		/* Same for port 6 with real external PHY. */
		unsigned short phycontrol = 0xC0C0;
		unsigned short deviceid = marvell_phy_read(0x6, 0x3);
		if ((deviceid & 0xFFF0) == 0x1640) {
			printf("KSZ9131RNX on port 6 detected\n");
			/* No RX delay HYP-28912 */
			phycontrol = 0x40C0;
		} else {
			printf("KSZ9031RNX on port 6\n");
		}
		miiphy_read(devname, 0x16, 0x1, &val);
		val |= phycontrol;
		miiphy_write(devname, 0x16, 0x1, val);
#endif
	}
#endif

	if (phydev->drv->config)
		phydev->drv->config(phydev);

	return 0;
}
#endif

int board_eth_init(struct bd_info *bis)
{
#if defined(CONFIG_BOARD_IS_HIMX_IPCAM)
	return 0;
#else
	uint32_t base = IMX_FEC_BASE;
	struct mii_dev *bus = NULL;
	struct phy_device *phydev = NULL;
	int ret;

	setup_iomux_enet();
	cpu_eth_init(bis);

#ifdef CONFIG_FEC_MXC
	bus = fec_get_miibus(base, -1);
	if (!bus)
		return -EINVAL;
	/* scan phy 0 and 16 */
	phydev = phy_find_by_mask(bus, 0x10001);
	if (!phydev) {
		ret = -EINVAL;
		goto free_bus;
	}
	printf("using phy at %d\n", phydev->addr);
	ret  = fec_probe(bis, -1, base, bus, phydev);
	if (ret)
		goto free_phydev;
#endif

#if defined(CONFIG_USB_ETHER) && defined(CONFIG_USB_MUSB_GADGET)
	/* For otg ethernet*/
	usb_eth_initialize(bis);
#endif
	return 0;
free_phydev:
	free(phydev);
free_bus:
	free(bus);
	return ret;
#endif // else defined(CONFIG_BOARD_IS_HIMX_IPCAM)
}

#if defined(CONFIG_VIDEO_IPUV3)

static iomux_v3_cfg_t const backlight_pads[] = {
	/* Backlight on LVDS connector */
	MX6_PAD_SD1_CMD__GPIO1_IO18 | MUX_PAD_CTRL(NO_PAD_CTRL),
#define LVDS_BACKLIGHT_GP IMX_GPIO_NR(1, 18)
};

static void do_enable_hdmi(struct display_info_t const *dev)
{
	imx_enable_hdmi_phy();
}

static int detect_i2c(struct display_info_t const *dev)
{
	return ((0 == i2c_set_bus_num(dev->bus))
		&&
		(0 == i2c_probe(dev->addr)));
}

static void enable_lvds(struct display_info_t const *dev)
{
	struct iomuxc *iomux = (struct iomuxc *)
				IOMUXC_BASE_ADDR;
	u32 reg = readl(&iomux->gpr[2]);
	reg |= IOMUXC_GPR2_DATA_WIDTH_CH0_24BIT;
	writel(reg, &iomux->gpr[2]);
	gpio_direction_output(LVDS_BACKLIGHT_GP, 1);
}

struct display_info_t const displays[] = {{
	.bus	= 0,
	.addr	= 0x50,
	.pixfmt	= IPU_PIX_FMT_RGB24,
	.detect	= detect_i2c,
	.enable	= do_enable_hdmi,
	.mode	= {
		.name           = "HDMI",
		.refresh        = 60,
		.xres           = 1024,
		.yres           = 768,
		.pixclock       = 15385,
		.left_margin    = 220,
		.right_margin   = 40,
		.upper_margin   = 21,
		.lower_margin   = 7,
		.hsync_len      = 60,
		.vsync_len      = 10,
		.sync           = FB_SYNC_EXT,
		.vmode          = FB_VMODE_NONINTERLACED
} }, {
	.bus	= 0,
	.addr	= 0,
	.pixfmt	= IPU_PIX_FMT_RGB24,
	.detect	= NULL,
	.enable	= enable_lvds,
	.mode	= {
		.name           = "LDB-WXGA",
		.refresh        = 60,
		.xres           = 1280,
		.yres           = 768,
		.pixclock       = 12578,
		.left_margin    = 192,
		.right_margin   = 64,
		.upper_margin   = 3,
		.lower_margin   = 20,
		.hsync_len      = 128,
		.vsync_len      = 7,
		.sync           = FB_SYNC_EXT,
		.vmode          = FB_VMODE_NONINTERLACED
} } };
size_t display_count = ARRAY_SIZE(displays);

int board_cfb_skip(void)
{
	return NULL != env_get("novideo");
}

static void setup_display(void)
{
	struct mxc_ccm_reg *mxc_ccm = (struct mxc_ccm_reg *)CCM_BASE_ADDR;
	struct iomuxc *iomux = (struct iomuxc *)IOMUXC_BASE_ADDR;
	int reg;

	enable_ipu_clock();
	imx_setup_hdmi();
	/* Turn on LDB0,IPU,IPU DI0 clocks */
	reg = __raw_readl(&mxc_ccm->CCGR3);
	reg |=  MXC_CCM_CCGR3_LDB_DI0_MASK;
	writel(reg, &mxc_ccm->CCGR3);

	/* set LDB0, LDB1 clk select to 011/011 */
	reg = readl(&mxc_ccm->cs2cdr);
	reg &= ~(MXC_CCM_CS2CDR_LDB_DI0_CLK_SEL_MASK
		 |MXC_CCM_CS2CDR_LDB_DI1_CLK_SEL_MASK);
	reg |= (3<<MXC_CCM_CS2CDR_LDB_DI0_CLK_SEL_OFFSET)
	      |(3<<MXC_CCM_CS2CDR_LDB_DI1_CLK_SEL_OFFSET);
	writel(reg, &mxc_ccm->cs2cdr);

	reg = readl(&mxc_ccm->cscmr2);
	reg |= MXC_CCM_CSCMR2_LDB_DI0_IPU_DIV;
	writel(reg, &mxc_ccm->cscmr2);

	reg = readl(&mxc_ccm->chsccdr);
	reg |= (CHSCCDR_CLK_SEL_LDB_DI0
		<<MXC_CCM_CHSCCDR_IPU1_DI0_CLK_SEL_OFFSET);
	writel(reg, &mxc_ccm->chsccdr);

	reg = IOMUXC_GPR2_BGREF_RRMODE_EXTERNAL_RES
	     |IOMUXC_GPR2_DI1_VS_POLARITY_ACTIVE_HIGH
	     |IOMUXC_GPR2_DI0_VS_POLARITY_ACTIVE_LOW
	     |IOMUXC_GPR2_BIT_MAPPING_CH1_SPWG
	     |IOMUXC_GPR2_DATA_WIDTH_CH1_18BIT
	     |IOMUXC_GPR2_BIT_MAPPING_CH0_SPWG
	     |IOMUXC_GPR2_DATA_WIDTH_CH0_18BIT
	     |IOMUXC_GPR2_LVDS_CH1_MODE_DISABLED
	     |IOMUXC_GPR2_LVDS_CH0_MODE_ENABLED_DI0;
	writel(reg, &iomux->gpr[2]);

	reg = readl(&iomux->gpr[3]);
	reg = (reg & ~(IOMUXC_GPR3_LVDS0_MUX_CTL_MASK
			|IOMUXC_GPR3_HDMI_MUX_CTL_MASK))
	    | (IOMUXC_GPR3_MUX_SRC_IPU1_DI0
	       <<IOMUXC_GPR3_LVDS0_MUX_CTL_OFFSET);
	writel(reg, &iomux->gpr[3]);

	/* backlights off until needed */
	imx_iomux_v3_setup_multiple_pads(backlight_pads,
					 ARRAY_SIZE(backlight_pads));
	gpio_direction_input(LVDS_BACKLIGHT_GP);
}
#endif

int board_early_init_f(void)
{
	setup_iomux_uart();

#if defined(CONFIG_VIDEO_IPUV3)
	setup_display();
#endif
	return 0;
}

/*
 * Do not overwrite the console
 * Use always serial for U-Boot console
 */
int overwrite_console(void)
{
	return 1;
}

int board_init(void)
{
	struct iomuxc *const iomuxc_regs = (struct iomuxc *)IOMUXC_BASE_ADDR;

	clrsetbits_le32(&iomuxc_regs->gpr[1],
			IOMUXC_GPR1_OTG_ID_MASK,
			IOMUXC_GPR1_OTG_ID_GPIO1);

	imx_iomux_v3_setup_multiple_pads(misc_pads, ARRAY_SIZE(misc_pads));


	/* address of boot parameters */
	gd->bd->bi_boot_params = PHYS_SDRAM + 0x100;

#ifdef CONFIG_MXC_SPI
	setup_spi();
#endif
	setup_i2c(0, CONFIG_SYS_I2C_SPEED, 0x7f, &i2c_pad_info0);
	setup_i2c(1, CONFIG_SYS_I2C_SPEED, 0x7f, &i2c_pad_info1);
	setup_i2c(2, CONFIG_SYS_I2C_SPEED, 0x7f, &i2c_pad_info2);

#if defined(CONFIG_BOARD_IS_HIMX_IPCAM)
	return 0;
#else
	SETUP_IOMUX_PADS(usdhc3_pads);
	SETUP_IOMUX_PADS(usdhc4_pads);
#ifdef CONFIG_SATA
	setup_sata();
#endif

#if defined(CONFIG_BOARD_IS_HIMX_DVMON)
	// Enable USB
	gpio_request(IMX_GPIO_NR(3, 31), "Enable USB");
	gpio_direction_output(IMX_GPIO_NR(3, 31), 1);
	// Enable Touchscreen
	gpio_request(IMX_GPIO_NR(1, 0), "Enable touchscreen");
	gpio_direction_output(IMX_GPIO_NR(1, 0), 0);
#else
	gpio_request(IMX_GPIO_NR(4, 4), "???");
	gpio_direction_output(IMX_GPIO_NR(4, 4), 1);
	gpio_set_value(IMX_GPIO_NR(4, 4), 0);
	udelay(1000);
	gpio_set_value(IMX_GPIO_NR(4, 4), 1);
#endif
	return 0;
#endif // else defined(CONFIG_BOARD_IS_HIMX_IPCAM)
}

int board_late_init(void)
{
#if defined(CONFIG_BOARD_IS_HIMX_IVAP)
	gpio_direction_input(ENET_RX_ER_GP);
	if (0 == gpio_get_value(ENET_RX_ER_GP) &&
	    !strcmp(env_get("fdt_file"), CONFIG_DEFAULT_FDT_FILE)) {
		char *fdt = HIMX_DEFAULT_FDT_FILE_DVREC;
		printf("Detected DVREC\n");
		if (is_cpu_type(MXC_CPU_MX6QP)) {
			fdt = HIMX_DEFAULT_FDT_FILE_DVREC_P;
		}
		if (env_set("fdt_file", fdt)) {
			printf("env_set: fdt_file '%s' failed\n", fdt);
		}
	}
#elif defined(CONFIG_BOARD_IS_HIMX_DVMON)
	/* If a touch controller is detected, then the touch display is
	   connected and the alternative device tree is used. */
	int found_5c = 0;
	i2c_set_bus_num(0);
	for(int i=0; i<5; ++i) {
		if(0 == i2c_probe(0x5c)) {
			found_5c = 1;
			break;
		}
		udelay(200*1000);
	}
	if(found_5c) {
		if(!strcmp(env_get("fdt_file"), CONFIG_DEFAULT_FDT_FILE)) {
			char *fdt = HIMX_DEFAULT_FDT_FILE_DVMON_2;
			printf("dvmon: detected touch use alternative fdt\n");
			if (env_set("fdt_file", fdt)) {
				printf("env_set: fdt_file '%s' failed\n", fdt);
			}
		}
	}
#endif
	return 0;
}

int checkboard(void)
{
#if defined(CONFIG_BOARD_IS_HIMX_IMOC)
	puts("Board: himx0294-imoc\n");
#elif defined(CONFIG_BOARD_IS_HIMX_IVAP)
	puts("Board: himx0294-ivap/dvrec\n");
#elif defined(CONFIG_BOARD_IS_HIMX_DVMON)
	puts("Board: himx0294-dvmon\n");
#elif defined(CONFIG_BOARD_IS_HIMX_IPCAM)
	puts("Board: himx0294-ipcam\n");
#else
	puts("Board: himx0294-???\n");
#endif
	return 0;
}

#ifdef CONFIG_CMD_BMODE
static const struct boot_mode board_boot_modes[] = {
	/* 4 bit bus width */
	{"mmc0",	MAKE_CFGVAL(0x40, 0x30, 0x00, 0x00)},
	{"mmc1",	MAKE_CFGVAL(0x40, 0x38, 0x00, 0x00)},
	{NULL,		0},
};
#endif

int misc_init_r(void)
{
#if defined(CONFIG_BOARD_IS_HIMX_IVAP)
	gpio_request(ENET_RX_ER_GP, "Detect DVREC");
	gpio_request(IMX_GPIO_NR(4, 15), "Enable USB OTG PWR");
	gpio_request(IMX_GPIO_NR(1, 4), "Reset USB");
#endif

#ifdef CONFIG_CMD_BMODE
	add_board_boot_modes(board_boot_modes);
#endif
	return 0;
}
