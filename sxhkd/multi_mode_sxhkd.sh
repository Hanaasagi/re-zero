#!/bin/bash

set -ex

ModeFile="/dev/shm/sxhkd_mode"
ConfigFile="$HOME/.config/sxhkd/sxhkdrc"
BaseConfigFile="$HOME/.config/sxhkd/sxhkdrc_base"
MouseConfigFile="$HOME/.config/sxhkd/sxhkdrc_mouse"
NormalConfigFile="$HOME/.config/sxhkd/sxhkdrc_normal"
Action=$1

# ensue file exists
if [ ! -f $ModeFile ]; then
    touch $ModeFile
fi

if [ ! -f $ConfigFile ]; then
    touch $ConfigFile
fi


function reload() {
    pkill -USR1 -x sxhkd
    #notify-send "Sxhkd" "reload success" -t 2000 -u normal
}

function switch_to() {
    ToMode=$1

    truncate --size 0 $HOME/.config/sxhkd/sxhkdrc

    if [[ $ToMode == "NORMAL" ]]; then
        cat $BaseConfigFile  $NormalConfigFile > $ConfigFile
    elif [[ $ToMode == "MOUSE" ]]; then
        cat $BaseConfigFile  $MouseConfigFile > $ConfigFile
    else
        cat $BaseConfigFile $NormalConfigFile > $ConfigFile
    fi

    echo $ToMode > $ModeFile
}

function get_next_mode() {
    CurrentMode=$1

    case $CurrentMode in
        "NORMAL") echo "MOUSE";;
        "MOUSE") echo "NORMAL";;
        *) echo "NORMAL";;
    esac
}

function switch() {
    CurrentMode=$(cat $ModeFile)
    NextMode=$(get_next_mode $CurrentMode)

    switch_to $NextMode
    notify-send "Sxhkd" "switch to ${NextMode} mode" -t 2000 -u normal
}

function start() {
    switch_to "NORMAL"
    pgrep -x sxhkd > /dev/null || (sxhkd &)
    #notify-send "Startup" "sxhkd is up and running " -t 2000 -u normal
}


case $Action in
    start) start;;
    switch) switch; reload;;
    reload) reload;;
esac
