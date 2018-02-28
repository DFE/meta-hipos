#!/bin/bash

wait_sec=30;

while true
do
	/bin/sleep $((wait_sec))
	/usr/bin/vmstat | /usr/bin/logger -t vmstat
	/bin/cat /proc/buddyinfo | /usr/bin/logger -t vmstat
done

