#!/bin/bash

# Init modem and start pppd. Called from udev rule on ACTION add modem primary USB device.
# Works with Telit LE910 modem only.

SIM_PIN=""
APN=""
PPPD_USER=""
PPPD_PASSWORD=""

# default to always online
DIALUP=always

# read by pppd
PPPD_CONFIG_FILE=/etc/ppp/peers/dialup

CHAT_DBG_OPT="-v"

JSON_MODEM_CONFIG="/etc/drmodem/drmodem.json"
JSON_HELPER="/usr/bin/jsonhelper"

DIALUP_CONFIG_FILE=/etc/default/hydraip-networking

# NOTE: Do not change the following 4 lines, since they are necessary for the MR3060 function test.  
# MR3060 function test looks exactly for this line 20130429
MODEM_TEST_FILE="/tmp/modemtest"
MODEM_TEST_RESULT="Modem Test"
MODEM_TEST_RESULT_OK="Modem Test: OK"
MODEM_DRANOR="/var/run/dranor.modem"

PIN_ERROR_FILE="/tmp/3g-pin-error"         # used by /etc/init.d/3g-led; 3G status daemon HACK; see HYP-1755
MODEM_PRESENT_FILE="/tmp/3g-modem-present" # also used by /etc/init.d/3g-led; 3G status daemon HACK; see HYP-1755

#----------------------
#      FUNCTIONS

# trace function
trace_func()
{
	logger -t "MODEM" $@
}

# announce modem function test result
function_test_result()
{
	if [ -f $MODEM_TEST_FILE ];
	then
		echo "$@" > $MODEM_TEST_FILE
	fi

	# signal SIM PIN related error for /etc/init.d/3g-led (HYP-1755)
	echo "$@" | grep "SIM PIN" && echo "1" > "$PIN_ERROR_FILE"
}

# Telit LE910 modem power down
telit_powerdown()
{
	local PORT=$1

	chat $CHAT_DBG_OPT \
	ABORT 'ERROR' \
	TIMEOUT 5 \
	'' 'AT#SHDN' \
	'OK' '' \
	< $PORT > $PORT
}

# Check if GPS controller up
telit_nmea_is_up()
{
	local PORT=$1

	chat $CHAT_DBG_OPT \
	ABORT 'GPSP: 0' \
	ABORT 'ERROR' \
	TIMEOUT 10 \
	'' 'AT$GPSP?' \
	'GPSP: 1' '' \
	< $PORT > $PORT
}

# Start Telit LE910 NMEA
telit_nmea_start()
{
	local PORT=$1

	chat $CHAT_DBG_OPT -E \
	ABORT 'ERROR' \
	TIMEOUT 10 \
	'' 'AT\$GPSP=1' \
	'OK' '' \
	< $PORT > $PORT
}

# Stop Telit LE910 NMEA
telit_nmea_stop()
{
	local PORT=$1

	chat $CHAT_DBG_OPT -E \
	ABORT 'ERROR' \
	TIMEOUT 10 \
	'' 'AT\$GPSP=0' \
	'OK' '' \
	< $PORT > $PORT
}

# Telit LE910 NMEA data configuration
telit_nmea_data_configuration()
{
	local PORT=$1

	chat $CHAT_DBG_OPT \
	ABORT 'ERROR' \
	TIMEOUT 5 \
	'' 'AT$GPSNMUN=2,1,1,1,1,1,1' \
	'OK' '' \
	< $PORT > $PORT
}

# Get Telit packet service network type
telit_psnt()
{
	local PORT=$1

	chat \
	ABORT '#PSNT: 0,0' \
	ABORT '#PSNT: 0,1' \
	ABORT '#PSNT: 0,2' \
	ABORT '#PSNT: 0,3' \
	ABORT '#PSNT: 0,4' \
	ABORT '#PSNT: 0,5' \
	ABORT 'ERROR' \
	TIMEOUT 10 \
	'' 'AT#PSNT?' \
	'+MPDS: 0' '' \
	< $PORT > $PORT
}

# get at command output
get_at_output()
{
	local PORT=$1
	local AT_CMD=$2
	local AT_RESULT

	AT_RESULT=`\
	chat -e -v \
	ABORT 'ERROR' \
	TIMEOUT 2 \
	'' $AT_CMD \
	'OK\r' '' \
	2>&1 < $PORT > $PORT` || return

	#delete AT command, AT response
	echo $AT_RESULT | sed 's/^'$AT_CMD'//' | sed 's/ OK$//'
}

# simple at command 
test_at()
{
	local PORT=$1

	chat $CHAT_DBG_OPT \
	ABORT 'ERROR' \
	TIMEOUT 10 \
	'' 'AT' \
	'OK' '' \
	< $PORT > $PORT
}

# csq command 
test_csq()
{
	local PORT=$1

	chat $CHAT_DBG_OPT \
	ABORT 'ERROR' \
	TIMEOUT 10 \
	'' 'AT+CSQ' \
	'OK' '' \
	< $PORT > $PORT
}

# Get modem sim pin state
sim_pin_state()
{
	local PORT=$1

	chat $CHAT_DBG_OPT \
	ABORT '+CPIN: SIM PIN' \
	ABORT '+CPIN: SIM PUK' \
	ABORT '+CPIN: SIM PUK2' \
	ABORT 'ERROR' \
	TIMEOUT 10 \
	'' 'AT+CPIN?' \
	'+CPIN: READY' '' \
	< $PORT > $PORT
}

# Set modem sim pin
set_sim_pin()
{
	local PORT=$1
	local SIM_PIN=$2

	chat $CHAT_DBG_OPT -E \
	ABORT 'ERROR' \
	TIMEOUT 10 \
	'' AT+CPIN=$SIM_PIN \
	'OK' '' \
	< $PORT > $PORT
}

# Set modem cgdcont
set_cgdcont()
{
	local PORT=$1
	local APN=$2

	chat $CHAT_DBG_OPT -E \
	ABORT 'ERROR' \
	TIMEOUT 10 \
	'' AT+CGDCONT=1,\"IP\",\"$APN\" \
	'OK' '' \
	< $PORT > $PORT
}

# Get modem Network Registration Status
get_reg_state()
{
	local PORT=$1

	chat $CHAT_DBG_OPT \
	ABORT '+CREG: 0,0' \
	ABORT '+CREG: 0,2' \
	ABORT '+CREG: 0,3' \
	ABORT '+CREG: 0,4' \
	ABORT '+CREG: 0,5' \
	ABORT 'ERROR' \
	TIMEOUT 10 \
	'' 'AT+CREG?' \
	'+CREG: 0,1' '' \
	< $PORT > $PORT
}

# Set modem sim pin
check_sim_pin()
{
	local PORT=$1
	sim_pin_state $PORT
	PIN_STATE=$?
	count=0
	while [ $PIN_STATE -eq 7 ]
	do
		trace_func "SIM PIN state: $PIN_STATE"
		if [ $count -ge 10 ];
		then
			trace_func "Get SIM PIN state  failed : exit"
			function_test_result "$MODEM_TEST_RESULT: Get SIM PIN state failed"
			exit -1
		fi
		count=$(($count+1))
		if [ ! -c $PORT ];
		then
			trace_func "Get SIM PIN state: Port $PORT is no character special file : exit"
			function_test_result "$MODEM_TEST_RESULT: Port is no character special file"
			exit 1
		fi
		sleep 1
		sim_pin_state $PORT
		PIN_STATE=$?
	done
	case $PIN_STATE in
	0)
		trace_func "SIM PIN OK"
		;;
	1)
		trace_func "ERROR: chat parameter : exit"
		function_test_result "$MODEM_TEST_RESULT: error chat parameter"
		exit 1
		;;
	2)
		trace_func "ERROR: during chat execution : exit"
		function_test_result "$MODEM_TEST_RESULT: error during chat execution"
		exit 1
		;;
	3)
		trace_func "ERROR: timeout : exit"
		function_test_result "$MODEM_TEST_RESULT: error timeout"
		exit 1
		;;
	4)
		trace_func "Set SIM PIN"
		set_sim_pin $PORT $SIM_PIN
		if [ $? -ne 0 ] ;
		then
			trace_func "Set SIM PIN failed : exit"
			function_test_result "$MODEM_TEST_RESULT: Set SIM PIN failed"
			exit -1
		fi
		trace_func "wait SIM PIN ready"
		sim_pin_state $PORT
		PIN_STATE=$?
		trace_func "SIM PIN state: $PIN_STATE"
		count=0
		while [ $PIN_STATE -ne 0 ]
		do
			sleep 1
			sim_pin_state $PORT
			PIN_STATE=$?
			trace_func "SIM PIN state: $PIN_STATE"
			if [ $count -ge 10 ];
			then
				trace_func "Set SIM PIN failed : exit"
				function_test_result "$MODEM_TEST_RESULT: Set SIM PIN failed"
				exit -1
			fi
			count=$(($count+1))
			if [ ! -c $PORT ];
			then
				trace_func "Set SIM PIN: Port $PORT is no character special file : exit"
				function_test_result "$MODEM_TEST_RESULT: Port is no character special file"
				exit 1
			fi
		done
		trace_func "SIM PIN READY"
		;;
	5)
		trace_func "need SIM PUK : exit"
		function_test_result "$MODEM_TEST_RESULT: need SIM PUK"
		exit 1
		;;
	6)
		trace_func "need SIM PUK2 : exit"
		function_test_result "$MODEM_TEST_RESULT: need SIM PUK2"
		exit 1
		;;
	7)
		trace_func "Received ERROR : exit"
		function_test_result "$MODEM_TEST_RESULT: received error"
		exit 1
		;;
	*)
		trace_func "SIM PIN unexpected result : exit"
		function_test_result "$MODEM_TEST_RESULT: unexpected result"
		exit 1
		;;
	esac
}

# Wait for modem network registration
wait_modem_registration()
{
	local PORT=$1
	get_reg_state $PORT
	CREG=$?

	count=0
	while [ $CREG -ne 0 -a $CREG -ne 8 ]
	do
		if [ $CREG -eq 9 ];
		then
			trace_func "CREG failed, error : exit"
			function_test_result "$MODEM_TEST_RESULT: CREG failed, error"
			exit 1
		fi
		if [ $CREG -eq 6 ];
		then
			trace_func "CREG failed, Registration denied : exit"
			function_test_result "$MODEM_TEST_RESULT: CREG failed, Registration denied"
			exit 1
		fi
		if [ $count -gt 20 ] ;
		then
			if [ -f $MODEM_TEST_FILE ];
			then
				trace_func "CREG failed, Registration timeout : exit"
				function_test_result "$MODEM_TEST_RESULT: CREG failed, Registration timeout"
				exit 1
			fi
		fi
		count=$(($count+1))
		sleep 1
		if [ ! -c $PORT ];
		then
			trace_func "Port $PORT is no character special file : exit"
			function_test_result "$MODEM_TEST_RESULT: no character special file"
			exit 1
		fi
		get_reg_state $PORT
		CREG=$?
		trace_func "Modem registration state: $CREG"
	done
	trace_func "Modem registration OK"
}

# check gps configuration
check_gps_configuration()
{
	GPS_MODE=`$JSON_HELPER -f $JSON_MODEM_CONFIG -s motorola-H24-gps/mode`
	if [ $? -ne 0 ];
	then
		trace_func "Get motorola-H24-gps/mode failed. json configuration file: $JSON_MODEM_CONFIG"
		return 2
	fi
	if [ "$GPS_MODE" == "" ];
	then
		trace_func "motorola-H24-gps/mode is empty. json configuration file: $JSON_MODEM_CONFIG"
		return 1
	fi

	GPS_VOLT=`$JSON_HELPER -f $JSON_MODEM_CONFIG -s motorola-H24-gps/volt`
	if [ $? -ne 0 ];
	then
		trace_func "Get motorola-H24-gps/volt failed. json configuration file: $JSON_MODEM_CONFIG"
	else
		if [ "$GPS_VOLT" == "" ];
		then
			trace_func "motorola-H24-gps/volt is empty. json configuration file: $JSON_MODEM_CONFIG"
			return 0
		fi
	fi

	trace_func "GPS Config OK. mode: $GPS_MODE volt: $GPS_VOLT"
	return 0
}

# check umts configuration
check_umts_configuration()
{
	SIM_PIN=`$JSON_HELPER -f $JSON_MODEM_CONFIG -s modems[0]/simpin`
	if [ $? -ne 0 ];
	then
		trace_func "Get modems[0]/simpin failed. json configuration file: $JSON_MODEM_CONFIG"
		return 2
	fi
	if [ "$SIM_PIN" == "" ];
	then
		trace_func "SIM PIN modems[0]/simpin is empty. json configuration file: $JSON_MODEM_CONFIG"
		return 1
	fi

	APN=`$JSON_HELPER -f $JSON_MODEM_CONFIG -s modems[0]/apn`
	if [ $? -ne 0 ];
	then
		trace_func "Get modems[0]/apn failed. json configuration file: $JSON_MODEM_CONFIG"
		return 1
	fi
	if [ "$APN" == "" ];
	then
		trace_func "APN modems[0]/apn is empty. json configuration file: $JSON_MODEM_CONFIG"
		return 1
	fi

	if [ -f $DIALUP_CONFIG_FILE ];
	then 
		. $DIALUP_CONFIG_FILE
	else
		trace_func "Missing dialup config file $DIALUP_CONFIG_FILE. Using script defaults."
	fi

	PPPD_USER=`$JSON_HELPER -f $JSON_MODEM_CONFIG -s modems[0]/user`
	PPPD_PASSWORD=`$JSON_HELPER -f $JSON_MODEM_CONFIG -s modems[0]/password`

	SHOW_USER=$PPPD_USER
	[ "$SHOW_USER" == "" ] && SHOW_USER="no user name"
	SHOW_PASSWORD="available"
	[ "$PPPD_PASSWORD" == "" ] && SHOW_PASSWORD="no password"

	trace_func "Config OK. SIM_PIN: available APN: $APN USER: $SHOW_USER PASSWORD: $SHOW_PASSWORD DIALUP: $DIALUP"
	return 0
}

# check modem configuration
check_modem_configuration()
{
	local PORT=$1

	if [ ! -f $JSON_MODEM_CONFIG ];
	then
		trace_func "Missing modem json configuration file: $JSON_MODEM_CONFIG"
		telit_powerdown $PORT
		exit 1
	fi

	check_umts_configuration
	UMTS_CONFIG_OK=$?
	check_gps_configuration
	GPS_CONFIG_OK=$?

	if [ $UMTS_CONFIG_OK -eq 0 -o $GPS_CONFIG_OK -eq 0 ];
	then
		return
	fi
	if [ $UMTS_CONFIG_OK -eq 1 -o $GPS_CONFIG_OK -eq 1 ];
	then
		exit 1
	fi
	telit_powerdown $PORT
	exit 1
}

# activate Telit LE910 internal gps
telit_activate_gps()
{
	local PORT=$1
	
	telit_nmea_data_configuration  $PORT $ACTIVATE
	if [ $? -ne 0 ];
	then
		trace_func "Telit gps nmea configuration failed"
		return
	fi
	telit_nmea_is_up $PORT || telit_nmea_start $PORT
	if [ $? -ne 0 ];
	then
		trace_func "Telit start gps nmea failed"
		return
	fi
}

get_modem_identity()
{
	MODEM_FW=`get_at_output $SECONDARY_PORT AT+GMR`
	RET=$?
	if [ $RET -eq 0 ];
	then 
		echo $MODEM_FW > /tmp/modem_fw
	else
		trace_func "Get modem fw version failed: $RET"
	fi
	MODEM_SERIAL=`get_at_output $SECONDARY_PORT AT+GSN`
	RET=$?
	if [ $RET -eq 0 ];
	then 
		echo $MODEM_SERIAL > /tmp/modem_serial
	else
		trace_func "Get modem serial failed: $RET"
	fi
}

# exit script
function_test_exit()
{
	trace_func "$1: exit"
	function_test_result "$1"
	exit 1
}

# modem function test
function_test()
{
	local PORT=$1
	local MODEM_CONNECT=/tmp/modem_connectcheck

	if [ -f $MODEM_TEST_FILE ];
	then
		[ ! -f "$MODEM_CONNECT" ] && function_test_exit "$MODEM_TEST_RESULT: missing modem function test file $MODEM_CONNECT"

		source $MODEM_CONNECT
		telit_nmea_is_up $PORT || telit_nmea_start $PORT
		[ $? -ne 0 ] && function_test_exit "$MODEM_TEST_RESULT: power up NMEA failed"

		trace_func "Modem function test"
		while [ -c $PORT ]
		do
			ifconfig 2>/dev/null | grep -q "^ppp0" && ping --count 1 --timeout 10 "$CONNECT_HOST"
			if [ $? -eq 0 ];
			then
				trace_func "Functiontest ppp0 and host $CONNECT_HOST ready"
				break;
			else
				trace_func "Functiontest ppp0 or host $CONNECT_HOST not ready"
				sleep 1
			fi
		done
		[ ! -c $PORT ] && function_test_exit "$MODEM_TEST_RESULT: port $PORT lost"

		# add route to connection test host with ppp0 as gateway
		PPP_GW=`ifconfig ppp0 | grep 'inet addr:' | cut -d: -f3| cut -d' ' -f1`
		route add $CONNECT_HOST gw $PPP_GW

		trace_func "Modem function test: upload data"
		local REMOTE_NAME=`date +"%Y%m%d_%H%M%S_"`
		REMOTE_NAME=$REMOTE_NAME`cat /tmp/modem_serial | cut -d: -f 4 | tr -d " "`
		scp -i "$CONNECT_PRIVKEY" -oStrictHostKeyChecking=no -oConnectTimeout=60 /tmp/modem_serial "$CONNECT_USER"@"$CONNECT_HOST":"$CONNECT_PATH/$REMOTE_NAME"
		[ $? -ne 0 ] && function_test_exit "$MODEM_TEST_RESULT: scp upload file failed"

		trace_func "Modem function test: download data"
		scp -i "$CONNECT_PRIVKEY" -oStrictHostKeyChecking=no -oConnectTimeout=60 "$CONNECT_USER"@"$CONNECT_HOST":"$CONNECT_PATH/$REMOTE_NAME" /tmp/modem_serial_download
		[ $? -ne 0 ] && function_test_exit "$MODEM_TEST_RESULT: scp download file failed"

		trace_func "Modem function test: comparing upload with download"
		diff -q /tmp/modem_serial /tmp/modem_serial_download
		[ $? -ne 0 ] && function_test_exit "$MODEM_TEST_RESULT: scp files differ"

		count=0
		while [ -c $PORT ]
		do
			GPS_TRACKING=`chat -e -v ABORT 'ERROR' TIMEOUT 15 '' 'AT\$GPSACP' 'OK' '' 2>&1 < $PORT > $PORT`
			if [ $? -eq 0 ];
			then
				GPS_DATA=${GPS_TRACKING##* }
				echo "$GPS_DATA" > /tmp/modem_gps
				GPS_TIME=`echo $GPS_DATA | cut -d ',' -f 1`
				GPS_LAT=`echo $GPS_DATA | cut -d ',' -f 2`
				GPS_LAT_NS=`echo ${GPS_LAT: -1}`
				GPS_LONG=`echo $GPS_DATA | cut -d ',' -f 3`
				GPS_LONG_EW=`echo ${GPS_LONG: -1}`
				GPS_DATE=`echo $GPS_DATA | cut -d ',' -f 10`
				GPS_NR_SATELLITE=`echo $GPS_DATA | cut -d ',' -f 11`

				trace_func "$MODEM_TEST_RESULT: \$GPSACP: $GPS_DATE $GPS_TIME"
				trace_func "$MODEM_TEST_RESULT: \$GPSACP: $GPS_LAT"
				trace_func "$MODEM_TEST_RESULT: \$GPSACP: $GPS_LONG"
				trace_func "$MODEM_TEST_RESULT: \$GPSACP: satellite $GPS_NR_SATELLITE"
				[ $GPS_NR_SATELLITE -ge 3 -a "$GPS_LAT_NS" == "N" -a "$GPS_LONG_EW" == "E" ] && break;
			fi
			[ $count -gt 20 ] && function_test_exit "$MODEM_TEST_RESULT: wait gps data: timeout"
			count=$(($count+1))
		done
		[ ! -c $PORT ] && function_test_exit "$MODEM_TEST_RESULT: \$GPSACP: port $PORT lost"

		trace_func "$MODEM_TEST_RESULT_OK"
		function_test_result "$MODEM_TEST_RESULT_OK"
		exit 0;
	fi
}

function log_qos()
{
        local PORT=$1
        local LOGSTRING
        local TMP=/tmp/3gmodemreply

        chat -e ABORT 'ERROR' TIMEOUT 1 '' AT+CSQ 'OK' '' < $PORT > $PORT 2> $TMP
        LOGSTRING=`grep "^+CSQ:" $TMP`
        if [[ "$LOGSTRING" =~ .*:\ *([0-9]*) ]]; then QUALITY=${BASH_REMATCH[1]}; else QUALITY=0; fi

        chat -e ABORT 'ERROR' TIMEOUT 1 '' 'AT$GPSACP' 'OK' '' < $PORT > $PORT 2> $TMP
        LOGSTRING=$LOGSTRING"; "`grep '^$GPSACP:' $TMP`

        chat -e ABORT 'ERROR' TIMEOUT 1 '' AT+CGATT? 'OK' '' < $PORT > $PORT 2> $TMP
        LOGSTRING=$LOGSTRING"; "`grep '^+CGATT:' $TMP`
        logger -t 3G-Modem $LOGSTRING

        echo "$REG_TYPE:$QUALITY" > $MODEM_DRANOR.new; mv $MODEM_DRANOR.new $MODEM_DRANOR
}

set_pppd_parameter()
{
	local KEY=$1
	local VAL=$2

	CURR_KEY=`grep "^$KEY " "$PPPD_CONFIG_FILE"`
	if [ $? -eq 0 ];
	then
		CURR_VAL=${CURR_KEY#* }

		if [ "$VAL" != "$CURR_VAL" ];
		then
			sed -i "s/^$KEY .*/$KEY $VAL/" "$PPPD_CONFIG_FILE"
		fi
	else
		echo "$KEY $VAL" >> $PPPD_CONFIG_FILE
	fi
}

#-------------------
# THE MAIN FUNCTION
main()
{
	# clean up previous errors; part of 3G status daemon HACK, see HYP-1755
	rm "$PIN_ERROR_FILE" "$MODEM_PRESENT_FILE"

	PRIMARY_PORT=/dev/modem_ppp
	SECONDARY_PORT=/dev/modem_at
	# disable cr to nl translation and XON/XOFF protocol
	stty -F $SECONDARY_PORT -icrnl -ixon -ixoff

	if [ ! -c $PRIMARY_PORT ];
	then
		trace_func "Primary port $PRIMARY_PORT is no character special file : exit"
		exit 1
	fi

	count=0
	while [ ! -c $SECONDARY_PORT ]
	do
		trace_func "Wait for secondary port $SECONDARY_PORT"
		if [ $count -ge 60 ];
		then
			trace_func "Secondary port $SECONDARY_PORT is no character special file : exit"
			exit 1
		fi
		if [ ! -c $PRIMARY_PORT ];
		then
			trace_func "Primary port $PRIMARY_PORT is no character special file : exit"
			exit 1
		fi
		count=$(($count+1))
		sleep 1
	done

	get_modem_identity

	if [ -f $MODEM_TEST_FILE ];
	then
		JSON_MODEM_CONFIG="$MODEM_TEST_FILE" 
	fi

	check_modem_configuration $SECONDARY_PORT

	if [ $GPS_CONFIG_OK -eq 0 ];
	then
		trace_func "Activate GPS"
		telit_activate_gps $SECONDARY_PORT 1
	else
		trace_func "Deactivate GPS"
		telit_nmea_stop $SECONDARY_PORT
	fi

	if [ $UMTS_CONFIG_OK -ne 0 ];
	then
		exit 0
	fi
	check_sim_pin $SECONDARY_PORT

	set_cgdcont $SECONDARY_PORT $APN
	if [ $? -ne 0 ];
	then
		trace_func "Set cgdcont failed APN: $APN : exit"
		exit 1
	fi

	# signal SIM PIN related error for /etc/init.d/3g-led (HYP-1755)
	echo "0" > "$MODEM_PRESENT_FILE"

	wait_modem_registration $SECONDARY_PORT

	set_pppd_parameter user "$PPPD_USER"
	set_pppd_parameter password "$PPPD_PASSWORD"

	if [ "$DIALUP" = "always" ];
	then
		trace_func "Now dialling..."
		systemctl start modem-ppp.service
	else
		trace_func "Modem initialised and ready to use."
	fi

	function_test $SECONDARY_PORT

	# check modem state (HYP-1799) 
	count=0
	while [ -c $SECONDARY_PORT ]
	do
		if [ $count -ge 10 ];
		then
			telit_psnt $SECONDARY_PORT
			case "$?" in
			4) echo "1 registered/GPRS"  > "$MODEM_PRESENT_FILE"; REG_TYPE=GPRS ;;
			5) echo "1 registered/EDGE"  > "$MODEM_PRESENT_FILE"; REG_TYPE=EDGE ;;
			6) echo "1 registered/UMTS"  > "$MODEM_PRESENT_FILE"; REG_TYPE=UMTS ;;
			7) echo "1 registered/HSDPA" > "$MODEM_PRESENT_FILE"; REG_TYPE=HSDPA ;;
			8) echo "1 registered/LTE"   > "$MODEM_PRESENT_FILE"; REG_TYPE=LTE ;;
			*) echo "0 not_registered"   > "$MODEM_PRESENT_FILE"; REG_TYPE=offline ;;
			esac
			count=0
			log_qos $SECONDARY_PORT
		else
			count=$(($count+1))
		fi
		sleep 1
	done
	echo "off:0" > $MODEM_DRANOR.new; mv $MODEM_DRANOR.new $MODEM_DRANOR
}

main

