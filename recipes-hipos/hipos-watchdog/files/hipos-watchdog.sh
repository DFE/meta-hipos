#!/bin/bash
#
# Copyright (C) 2016-2023 DResearch Fahrzeugelektronik GmbH
#

if [ -a /var/run/lock/hipos-watchdog.lock ]; then
	exit
else
/bin/touch /var/run/lock/hipos-watchdog.lock
/bin/sleep 0.1
/usr/bin/drbcc --dev /dev/ttydrbcc --cmd gets | grep "Ignition: off" >/dev/null
if [  $? -eq 0 ]; then
	/bin/sleep 0.1
	/bin/systemctl --no-block poweroff
	exit
else
	/bin/sleep 0.1
	/usr/bin/drbcc --dev /dev/ttydrbcc --cmd="heartbeat 180"
	/bin/sleep 0.1
fi
/bin/rm /var/run/lock/hipos-watchdog.lock
fi

