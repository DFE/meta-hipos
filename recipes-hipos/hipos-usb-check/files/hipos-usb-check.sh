#!/bin/bash

if [ -e /lib/systemd/system/hip-opmode-normal.target ]
	then
		# wait for ip-opmode-normal.target on hipos-dfe
		systemctl status hip-opmode-normal.target
		while [ $? -ne 0 ]
		do
			sleep 10
			systemctl status hip-opmode-normal.target
		done
	else
		# wait 30s for usb resumes on HIPOS
		sleep 30;
fi

# get usb_resume count
usb_resume="$(dmesg | grep -i "imx_usb" | grep "usb: at imx_controller_resume" | wc -l)"

if [ "${usb_resume}" -ge 8 ]
	then
		echo "error: usb_resume count=${usb_resume} to high -> trigger reboot" | logger
		logger -t $0 "OnFailure called for usb check"
		while [[ `cat /proc/uptime | cut -d. -f1` -lt 180 ]]; do
			time_left=$(expr 180 - `cat /proc/uptime | cut -d. -f1`) 
			echo "error: usb_resume count=${usb_resume} to high -> trigger reboot in ${time_left}s" | logger
		        sleep 10
		done
		systemctl poweroff
		exit -1
	else
		echo "info: usb_resume count=${usb_resume} ok" | logger
fi

