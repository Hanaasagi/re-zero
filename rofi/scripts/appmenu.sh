#!/bin/bash

rofi -no-lazy-grab      \
-disable-history        \
-modi "drun" -show drun \
-sorting-method fzf     \
-sort                   \
-theme styles/appmenu.rasi
