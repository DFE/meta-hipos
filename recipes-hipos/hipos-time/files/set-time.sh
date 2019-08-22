#!/bin/bash

log() {
	logger -t set-time.sh $1
}

SUB_TYPE="$(/usr/sbin/hip-machinfo -s)"

# reset error signaling
rm -f /etc/drerrors/RTC.json 2> /dev/null

if [ "$SUB_TYPE" != "dvmon" -a "$SUB_TYPE" != "ipcam" ]; then
	date=$(drbcc --dev=/dev/ttydrbcc --cmd=getrtc | cut -d\  -f2,3)
	if [ -z "$date" ]; then
		# in case of problems we log the commands
		set -x
		for try in 1 2 3 4 5; do
			date=$(drbcc --dev=/dev/ttydrbcc --cmd=getrtc | cut -d\  -f2,3)
			if [ -n "$date" ]; then
				break
			fi
		done 2>&1 | log
		set +x
	fi
fi

# got last shutdown time
last=$(cat /lib/systemd/systemd-timesyncd 2> /dev/null)

# $date and $last may be empty or invalid here
if [ -n "$date" ]; then
	# empty battery
	if [[ "$date" < "2019" ]]; then
		log "Warning: RTC time outdated: $date"
		# signal error with LED
		echo "{\"error\":\"RTC time outdated: $date\"}" > /etc/drerrors/RTC.json
		if [ -n "$last" ]; then
			log "no RTC time, using last shutdown: $last"
			date -u -s "$last" > /dev/null
		fi
	else
		if [ -n "$last" ]; then
			# just warn if RTC time went backwards (or last shutdown not written)
			if [[ "$date" < "$last" ]]; then
				log "Warning: RTC time: $date before last shutdown: $last"
			fi
		else
			log "RTC: last shutdown time unknown"
		fi
		log "set system clock from RTC time: $date"
		date -u -s "$date" > /dev/null && touch /run/time-valid
	fi
else
	# dvmon and ipcam OR bcc read problems
	if [ -n "$last" ]; then
		log "no RTC time, using last shutdown: $last"
		date -u -s "$last" > /dev/null
	else
		log "Warning: no RTC time and last shutdown unknown"
	fi
fi
