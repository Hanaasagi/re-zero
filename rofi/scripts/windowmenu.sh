#!/bin/bash

rofi -no-lazy-grab      \
-disable-history        \
-modi "window" -show window \
-sorting-method fzf     \
-sort                   \
-theme styles/appmenu.rasi
