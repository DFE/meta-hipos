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

if [ -z "${lanspeed}" ]
then
	if [ "${MACHINE}" == "hikirk" ]
	then
		lanspeed=ff
	else
		lanspeed=f
	fi
fi

if [[ "${MACHINE}" == "hikirk" && "${#lanspeed}" = 1 ]]
then
	lanspeed="${lanspeed}f"
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

exit 0

