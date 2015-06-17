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
                else
                        echo "eth$i: use 100MBit/s"
                        ethtool -s eth$i advertise 0xF
        fi
done

if [ -a "/etc/hip-activate-config.d/${device}/net_config.py" ]
        then
                /etc/hip-activate-config.d/${device}/net_config.py
                if [ -a /etc/drconfig/post_config.sh ]
                        then
                                rm /etc/drconfig/post_config.sh
                        fi
fi


exit 0

