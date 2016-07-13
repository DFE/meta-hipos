#!/bin/bash

if [ -a /var/run/lock/hipos-watchdog.lock ]; then
	exit
else
/bin/touch /var/run/lock/hipos-watchdog.lock
/usr/bin/drbcc --dev /dev/ttydrbcc --cmd gets | grep "Ignition: off" >/dev/null
if [  $? -eq 0 ]; then
	/bin/systemctl --no-block poweroff
	exit
else
	/usr/bin/drbcc --dev /dev/ttydrbcc --cmd="heartbeat 180"
fi
/bin/rm /var/run/lock/hipos-watchdog.lock
fi

