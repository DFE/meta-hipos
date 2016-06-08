#!/bin/bash
PORT=/dev/modem_at

chat $CHAT_DBG_OPT -E \
ABORT 'ERROR' \
TIMEOUT 10 \
'' 'AT\$GPSP=1' \
'OK' '' \
< $PORT > $PORT
