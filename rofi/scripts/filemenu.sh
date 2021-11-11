#!/bin/bash

IGNORE="__pycache__"

cd $HOME
DIR="$(fd -E ${IGNORE} -L -d 4 --type d . | rofi -dmenu -i -p "~/" -sort-method fzf -sort -theme styles/filemenu.rasi)"
if [ -d "$DIR" ]; then
  dolphin $DIR
fi
