#!/bin/bash
TIME=`/usr/bin/drbcc --dev /dev/ttydrbcc --cmd=getrtc | awk '{ print $2 " " $3 }'`
date -u -s "$TIME"
