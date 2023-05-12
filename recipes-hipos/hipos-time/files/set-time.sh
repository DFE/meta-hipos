#!/bin/bash
#
# Copyright (C) 2015-2023 DResearch Fahrzeugelektronik GmbH
#

log() {
	logger -t set-time.sh $1
}

SUB_TYPE="$(/usr/sbin/hip-machinfo -s)"

# reset error signaling
rm -f /etc/drerrors/RTC.json

if [ "$SUB_TYPE" != "dvmon" ] && [ "$SUB_TYPE" != "ipcam" ] && [ "$SUB_TYPE" != "hybdmon" ]; then
	date_rtc=$(drbcc --dev=/dev/ttydrbcc --cmd=getrtc | cut -d\  -f2,3)
	if [ -z "$date_rtc" ]; then
		# in case of problems we log the commands
		set -x
		for try in 1 2 3 4 5; do
			date_rtc=$(drbcc --dev=/dev/ttydrbcc --cmd=getrtc | cut -d\  -f2,3)
			if [ -n "$date_rtc" ]; then
				break
			fi
		done 2>&1 | log
		set +x
	fi
fi

# got last shutdown time
last=$(cat /lib/systemd/systemd-timesyncd 2> /dev/null)
date_now=$(date --iso-8601=seconds)

# $date_rtc and $last may be empty or invalid here
if [ -n "$date_rtc" ]; then
	# empty battery
	if [[ "$date_rtc" < "2019" ]]; then
		log "Warning: RTC time outdated: $date_rtc"
		# signal error with LED
		mkdir -p /etc/drerrors
		echo "{\"error\":\"RTC time outdated: $date_rtc\"}" > /etc/drerrors/RTC.json
		if [ -n "$last" ]; then
			log "no RTC time, using last shutdown: $last"
			date -u -s "$last" > /dev/null
		fi
	else
		if [ -n "$last" ]; then
			# just warn if RTC time went backwards (or last shutdown not written)
			if [[ "$date_rtc" < "$last" ]]; then
				log "Warning: RTC time: $date_rtc before last shutdown: $last"
			fi
		else
			log "RTC: last shutdown time unknown"
		fi
		log "set system clock from RTC time: $date_rtc"
		date -u -s "$date_rtc" > /dev/null && touch /run/time-valid
	fi
else
	# dvmon, ipcam and hybdmon OR bcc read problems
	if [ -n "$last" ]; then
		if [[ "$last" > "$date_now" ]]; then
			log "no RTC time, using last shutdown: $last"
			date -u -s "$last" > /dev/null
		else
			log "no RTC time and last shutdown: $last before now time: $date_now"
		fi
	else
		log "Warning: no RTC time and last shutdown unknown"
	fi
fi
