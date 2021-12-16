#!/bin/bash
set -ex

Now=$(($(date +%s%N)/1000000))
PrevNow=$(($Now-500))
SwitchFile="/tmp/switch_hjkl"
SpeedFile="/dev/shm/sxhkd_mouse_speed"

# ensue file exists
touch $SwitchFile
touch $SpeedFile

Action=$1

shift

if [ -e "$SwitchFile" ] && [ "$(cat ${SwitchFile})" = "1" ]; then
    echo $(($(date +%s%N)/1000000)) >> $SpeedFile
    echo "$(tail -10 $SpeedFile)" > $SpeedFile

    Count=0
    while read -r line; do
        if [[ $line -ge $PrevNow && $line -le $Now ]]; then
            Count=$(($Count+1))
        fi
    done < $SpeedFile

    echo $Count >> /tmp/fuck

    Speed=$((8+$Count*6))

	case "$Action" in
	move_left) xdotool mousemove_relative -- -${Speed} 0 ;;
	move_right) xdotool mousemove_relative ${Speed} 0 ;;
	move_up) xdotool mousemove_relative -- 0 -${Speed} ;;
	move_down) xdotool mousemove_relative 0 ${Speed} ;;
	switch)
		echo 0 >${SwitchFile}
		notify-send "Switch hjkl" "switch to window move mode" -t 2000
		;;
	*)
		echo "Invalid Action"
		;;
	esac

else
	case "$Action" in
	move_left) bspc node -v -20 0 ;;
	move_right) bspc node -v 20 0 ;;
	move_up) bspc node -v 0, -20 ;;
	move_down) bspc node -v 0, 20 ;;
	switch)
		echo 1 >${SwitchFile}
		notify-send "Switch hjkl" "switch to mouse move mode" -t 2000
		;;
	*)
		echo "Invalid Action"
		;;
	esac

fi
