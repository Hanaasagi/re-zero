#!/bin/bash

INTERVAL=60
# trigger alert every 30 min
SUPPRESSION_SECONDS=1800
LOW_BATTERY=35
HIGH_BATTERY=95
LAST_TRIGGERED_AT=0
LOCKFILE="/tmp/check-battery.lock"
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "already running"
    exit
fi

# make sure the lockfile is removed when we exit and then claim it
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

while true; do
	battery_level=$(acpi -b | grep -P -o '[0-9]+(?=%)')
	now=$(date +%s)
	if [ $(($LAST_TRIGGERED_AT + $SUPPRESSION_SECONDS)) -le $now ]; then
		if [ $battery_level -ge $HIGH_BATTERY ]; then
			notify-send "Battery Full" "Level: ${battery_level}%"
			LAST_TRIGGERED_AT=$(date +%s)
		elif [ $battery_level -le $LOW_BATTERY ]; then
			notify-send --urgency=CRITICAL "Battery Low" "Level: ${battery_level}%"
			LAST_TRIGGERED_AT=$(date +%s)
		fi
	fi
	sleep $INTERVAL
done

rm -f ${LOCKFILE}

