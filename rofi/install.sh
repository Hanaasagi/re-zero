#!/bin/bash

SOURCEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step1: copy all rofi scripts.
if [[ -d $HOME/.local/bin ]]; then
    cp -r $SOURCEDIR/scripts/* $HOME/.local/bin
else
    mkdir $HOME/.local/bin && cp -r $SOURCEDIR/scripts/* $HOME/.local/bin
fi

if [[ -d $HOME/.config/rofi ]]; then
    #mkdir $HOME/.config/rofi.bak && mv $HOME/.config/rofi/* $HOME/.config/rofi.bak
    mkdir -p $HOME/.config/rofi/styles
    cp -r $SOURCEDIR/scripts/* $HOME/.config/rofi/
    cp -r $SOURCEDIR/styles/* $HOME/.config/rofi/styles/
else
    mkdir -p $HOME/.config/rofi/styles
    cp -r $SOURCEDIR/scripts/* $HOME/.config/rofi/
    cp -r $SOURCEDIR/styles/* $HOME/.config/rofi/styles
fi
