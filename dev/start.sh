#!/bin/bash

PID_FN="/run/obsrv.pid"
CFG_FN="/etc/cpptrde/config-obsrv.json"


if [ -f $PID_FN ];then
    if [ `ps aux | grep -c obsrv | grep -v grep` -eq 0 ];then
	rm $PID_FN
    else
        echo Daemon PID file already exists.
        exit 1
    fi
fi

# Start daemon
obsrv -c $CFG_FN -p $PID_FN
