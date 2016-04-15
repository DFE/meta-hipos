#!/bin/bash
date -u -s "$(drbcc --dev=/dev/ttydrbcc --cmd=getrtc | cut -d\  -f2,3)" ||
{  # in case of problems we log the commands
    set -x
    for try in 1 2 3 4 5; do
      date -u -s "$(drbcc --dev=/dev/ttydrbcc --cmd=getrtc | cut -d\  -f2,3)" && break
    done 2>&1 | logger -t $0
    set -x
}

