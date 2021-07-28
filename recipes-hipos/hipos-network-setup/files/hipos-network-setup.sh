#!/bin/bash

MACHINE="$(hip-machinfo -a)"

if [ -a /etc/hydraip-devid ]
then
	. /etc/hydraip-devid
fi

if [[ ( "${MACHINE}" == "himx0294-ivap" && "${vout}" -eq 2 ) || ( "${MACHINE}" == "himx0294-imoc" ) ]]
then
	exit 0
fi

if [[ "${MACHINE}" == "himx0294-impec" ]]
then
	ethtool -A eth0 rx on tx on
	exit 0
fi

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

if [ "${MACHINE}" == "himx0294-ivap" ] || [ "${MACHINE}" == "himx0294-dvmon" ]
then
	# Check PHY identifier 1 and part of PHY identifier 2
	if mdio 0 2 | grep -q "state 0x22" && mdio 0 3 | grep -q "state 0x162";
	then
		# Enable symmetric pause
		mdio 0x0 0x4 0x5e1
		# Restart auto-negotiation process
		mdio 0x0 0x0 0x1340
	fi
fi

exit 0

