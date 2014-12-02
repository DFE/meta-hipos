#!/bin/bash
# vim:set ts=4 sw=4 noexpandtab:
#
# \brief  BCC device info reader
# \description This script creates oder updates DEVID_FILE from BCC info. An update is
#              not executed if the serial number from BCC is invalid but the info on 
#              local root is valid. The script can be sourced to set all variables in DEVID_FILE.
# \author Ralf Schröder
#
# (C) 2013 DResearch Fahrzeugelektonik GmbH


#set -x

NAME="$0"
BCTRL_DEV="/dev/ttydrbcc"
DRBCC_BIN="/usr/bin/drbcc"
DEVID_FILE="/etc/hydraip-devid"
TMP_DEVID_FILE="/tmp/hipos-devid"
HOSTNAME_FILE="/etc/hostname"
# existence of this is checked within systemd scripts to start services 
# depending on device type e.g. hipos-device.nas or hipos-device.recorder
DEVICE_FILE_START="/etc/hipos/hipos-device"

loggerANDstdoutError()
{
	echo "E: $@" 2>&1
	logger -t ${NAME} -p user.err "$@"
}

if [ ! -x "$DRBCC_BIN" ]; then
	loggerANDstdoutError "${DRBCC_BIN} not found"
	exit 1
fi

serial_valid()
{
	case $1 in
		[0-9][0-9][0-9][0-9]-[0-9]-[0-9][0-9][0-9][0-9][0-9]) return 0 ;;
		*) return 1 ;;
	esac
}


fetch_info()
{
	local ret=0
	# fetch device info file from BCTRL
	local resp=`${DRBCC_BIN} --dev=${BCTRL_DEV} --cmd="gfiletype 0x50,${TMP_DEVID_FILE}" 2>&1`
	if [ ! -s ${TMP_DEVID_FILE} ]; then
		loggerANDstdoutError "No device identity info file available in BCTRL, drbcc resp: \'$resp\'"
		ret=1
		if [ ! -e ${DEVID_FILE} ]; then
			# create the minimal file to avoid later problems
			touch ${DEVID_FILE}
		fi
	else
		. ${TMP_DEVID_FILE}
		if [ -e ${DEVID_FILE} ]; then 
			if ! serial_valid "${serial}"; then
				test -e $DEVID_FILE  && . $DEVID_FILE 
				if serial_valid "${serial}"; then
					loggerANDstdoutError "serial number from info file available in BCTRL is invalid (old is ${serial}, drbcc resp: \'${resp}\')"
					ret=1
				fi
			fi
			if [ ${ret} -eq 0 ]; then
				# move only if different to avoid massive flash writing 
				diff -abq ${TMP_DEVID_FILE} ${DEVID_FILE} > /dev/null || mv -f ${TMP_DEVID_FILE} ${DEVID_FILE}
			fi
		else
			if ! serial_valid "${serial}"; then
				loggerANDstdoutError "serial number from info file available in BCTRL is invalid, but we will use it anyway (for lack of alternatives), drbcc resp: \'${resp}\')"
				ret=1
			fi
			mv -f ${TMP_DEVID_FILE} ${DEVID_FILE}
		fi      
	fi
	
	return ${ret}
}

update_device_type()
{
	local ret=0
	
	if [ -z "${device}" ]; then
		loggerANDstdoutError "no device set in device info file, using 'unknown' instead"
		device=unknown
		ret=1
	fi
	local device_file=${DEVICE_FILE_START}.${device}
	if [ ! -e "${device_file}" ]; then
		touch "${device_file}"
	fi
	local iter_file
	for iter_file in "${DEVICE_FILE_START}".* 
	do
		if [ "${device_file}" != "${iter_file}" ]; then
			rm "${iter_file}"
		fi
	done
	
	return ${ret}
}

update_hostname()
{
	local ret=0
	
	if serial_valid "${serial}" ; then
		if [[ ! -f "${HOSTNAME_FILE}" || "`cat ${HOSTNAME_FILE}`" == "hikirk" ]]; then
			# update only if hostname file does not exist or contains default "hikirk"
			echo ${serial} > ${HOSTNAME_FILE}
		fi
	else
		loggerANDstdoutError "No valid serial number found -> cannot update hostname"
		ret=1
	fi
	
	return ${ret}
}

# access the actual device config
# and actualize...
fetch_info
. ${DEVID_FILE}
update_device_type
update_hostname

# 'real' file is /etc/hydraip-devid. if this isn't the case yet, make it so
if [ -h ${DEVID_FILE} ]; then mv /etc/hipos/hipos-devid ${DEVID_FILE}; fi
# check the link in /etc/hipos
if [ ! -f /etc/hipos/hipos-devid ]; then ln -s ${DEVID_FILE} /etc/hipos/hipos-devid; fi
