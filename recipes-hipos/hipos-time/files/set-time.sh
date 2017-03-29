#!/bin/bash

MACHINE_TYPE="$(/usr/sbin/hip-machinfo -a)"
SUB_TYPE="$(/usr/sbin/hip-machinfo -s)"
VARIANT=$(. /etc/hydraip-devid; echo "${device:-recorder}")

ntpserver_config() {
        local lw
        if [ -f "/etc/drconfig/$MACHINE_TYPE-$VARIANT/topology.json" ]; then
                lw=$(jsonhelper -f "/etc/drconfig/$MACHINE_TYPE-$VARIANT/topology.json" -i LW)
        else
                lw=1
        fi
        jq -c -r .LW$lw.system.ntpserver "/etc/drconfig/$MACHINE_TYPE-$VARIANT/hydraip.json"
}

if [ "$SUB_TYPE" == "dvmon" ]; then
        ntpserver=$(ntpserver_config) &&
        if [ -n "$ntpserver" ]; then
                if ping -c1 -W1 $ntpserver 2>&1 > /dev/null ; then
                        if ntpq -p $ntpserver 2>&1 > /dev/null ; then
                                ntpd -gq $ntpserver &&
				touch /run/ntpd-synced
                        fi
                fi
        fi
else
        date -u -s "$(drbcc --dev=/dev/ttydrbcc --cmd=getrtc | cut -d\  -f2,3)" ||
        {  # in case of problems we log the commands
                set -x
                for try in 1 2 3 4 5; do
                date -u -s "$(drbcc --dev=/dev/ttydrbcc --cmd=getrtc | cut -d\  -f2,3)" && break
                done 2>&1 | logger -t $0
                set -x
        }
fi

