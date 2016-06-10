#!/bin/bash
PORT=/dev/modem_at

sleep 1.5

chat $CHAT_DBG_OPT \
ABORT 'ERROR' \
TIMEOUT 5 \
'' 'AT$GPSNMUN=2,1,1,1,1,1,1' \
'OK' '' \
< $PORT > $PORT

chat $CHAT_DBG_OPT -E \
ABORT 'ERROR' \
TIMEOUT 10 \
'' 'AT\$GPSP=1' \
'OK' '' \
< $PORT > $PORT
