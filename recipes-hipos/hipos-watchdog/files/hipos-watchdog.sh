#!/bin/bash

/usr/bin/drbcc --dev /dev/ttydrbcc --cmd gets | grep "Ignition: off" >/dev/null
if [  $? -eq 0 ]; then
	/bin/systemctl --no-block poweroff
else
	/usr/bin/drbcc --dev /dev/ttydrbcc --cmd="heartbeat 180"
fi

