#!/bin/bash

if [ -a /etc/hydraip-devid ]
        then
                . /etc/hydraip-devid
fi

if [ -z ${lanspeed} ]
        then
	        lanspeed=ff
	else
	if [ ${#lanspeed} = 1 ]
		then
			lanspeed=${lanspeed}f
	fi
fi

echo "lanspeed=$lanspeed"

for (( i=0; i<${#lanspeed}; i++ ))
do
        if [ "${lanspeed:$i:1}" == "g" ]
                then
                        echo "eth$i: use 1000MBit/s"
                        ethtool -s eth$i advertise 0xFF
                        ifconfig eth$i down
                        sleep 1
                        ifconfig eth$i up
                else
                        echo "eth$i: use 100MBit/s"
                        ethtool -s eth$i advertise 0xF
                        ifconfig eth$i down
                        sleep 1
                        ifconfig eth$i up
        fi
done

exit 0

