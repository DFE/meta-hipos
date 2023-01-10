#!/bin/bash

MACHINE="$(hip-machinfo -a)"

mmd_write_reg() {
	DEVICE=$1
	REG=$2
	VAL=$3

	mdio 0 0xd 0x${DEVICE}
	mdio 0 0xe 0x${REG}
	mdio 0 0xd 0x40${DEVICE}
	mdio 0 0xe ${VAL}
}

if [ -a /etc/hydraip-devid ]
then
	. /etc/hydraip-devid
fi

logger -t "hipos-network-setup.sh" "Setup network"

# Enable RX TX flow control pause frames HYP-29526
ethtool -A eth0 rx on tx on

if [[ ( "${MACHINE}" == "himx0294-ivap" && "${vout}" -eq 2 ) || ( "${MACHINE}" == "himx0294-imoc" ) ]]
then
	exit 0
fi

if [ "${MACHINE}" == "himx0294-ivap" ] || [ "${MACHINE}" == "himx0294-dvmon" ]
then
	if [ -z "${lanspeed}" ]
	then
		lanspeed=f
	fi

	echo "lanspeed=$lanspeed"

	for (( i=0; i<${#lanspeed}; i++ ))
	do
		if [ "${lanspeed:$i:1}" == "g" ]
		then
			echo "eth$i: use 1000MBit/s"
			ethtool -s eth$i advertise 0xFF
		else
			echo "eth$i: use 100MBit/s"
			ethtool -s eth$i advertise 0xF
		fi
	done

	# Check PHY identifier 1 and part of PHY identifier 2
	if mdio 0 2 | grep -q "state 0x22" && mdio 0 3 | grep -q "state 0x16";
	then
		# Control signal, rx data and clock delay.
		# Up to kernel 5.10 the fix was in the kernel.
		# Fix is needed by KSZ9031RNX and KSZ9131RNX
		mmd_write_reg 02 4 0x0
		mmd_write_reg 02 5 0x0
		mmd_write_reg 02 8 0x3ff

		# Enable symmetric pause
		mdio 0x0 0x4 0x5e1
		# Restart auto-negotiation process
		mdio 0x0 0x0 0x1340
	fi
elif [ "${MACHINE}" == "himx0294-impec" ]
then
	# Reset all phys to ensure a correct connection HYP-29558
	spi-reg 0x1d 0x20
	spi-reg 0x2d 0x20
	spi-reg 0x3d 0x20
	spi-reg 0x4d 0x20
fi

exit 0

