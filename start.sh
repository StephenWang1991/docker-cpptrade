#!/bin/bash

PID_FN="/run/obsrv.pid"
CFG_FN="/etc/cpptrde/config-obsrv.json"


# PID file cannot be present at start of tests
if [ -f $PID_FN ]
then
	echo Daemon PID file already exists.
	exit 1
fi

# Start daemon 
obsrv -c $CFG_FN -p $PID_FN

