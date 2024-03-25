#!/bin/bash
#
# Copyright (C) 2018-2024 DResearch Fahrzeugelektronik GmbH
#

wait_sec=60;
PRODUCT=$(/usr/sbin/hip-productname)
MACHINFO=$(/usr/sbin/hip-machinfo -a)
FWVERSION=$(lsb_release -r | cut -f 2)
FWCODENAME=$(lsb_release -c | cut -f 2)

while true
do
	/usr/bin/logger -t vmstat "${PRODUCT} ${MACHINFO} ${FWVERSION} (${FWCODENAME})"
	up_since=$(/usr/bin/uptime -s | tr -d "\n")
	up_pretty=$(/usr/bin/uptime -p | tr -d "\n")
	/usr/bin/logger -t vmstat "System up since $up_since $up_pretty"
	/usr/bin/vmstat -n $((wait_sec)) 2 | /usr/bin/logger -t vmstat
	/bin/cat /proc/buddyinfo | /usr/bin/logger -t vmstat
done

