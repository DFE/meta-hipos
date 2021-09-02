#!/bin/bash

wait_sec=30;

while true
do
	/bin/sleep $((wait_sec))
	/usr/bin/lsb_release -d | /usr/bin/logger -t vmstat
	up_since=$(/usr/bin/uptime -s | tr -d "\n")
	up_pretty=$(/usr/bin/uptime -p | tr -d "\n")
	/usr/bin/logger -t vmstat "System up since $up_since $up_pretty"
	/usr/bin/vmstat | /usr/bin/logger -t vmstat
	/bin/cat /proc/buddyinfo | /usr/bin/logger -t vmstat
done

