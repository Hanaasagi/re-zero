#!/bin/bash

blank='#00000000'  # blank
background='#1A5E81AC'
foreground='#D8DEE9FF'  # text

primary='#BF616AFF'  # default
alert='#EBCB8BFF'  # wrong
verifying='#A3BE8CFF'  # verifying

image_path="/home/kumiko/Pictures/Wallpapers/lockscreen.png"

i3lock \
--image=${image_path}               \
--fill                              \
\
--screen 1                          \
--indicator                         \
--keylayout 2                       \
--force-clock                       \
\
--insidever-color=$background       \
--insidewrong-color=$background     \
--inside-color=$background          \
\
--ringver-color=$primary            \
--ringwrong-color=$alert            \
--ring-color=$primary               \
\
--line-color=$primary               \
--line-uses-inside \
\
--keyhl-color=$alert                \
--bshl-color=$alert                 \
\
--separator-color=$primary          \
\
--verif-color=$foreground           \
--wrong-color=$foreground           \
--time-color=$foreground            \
--date-color=$foreground            \
--layout-color=$foreground          \
\
--time-align=0                      \
--date-align=0                      \
--layout-align=0                    \
--verif-align=0                     \
--wrong-align=0                     \
--modif-align=0                     \
\
--blur 5                            \
--indicator                         \
--keylayout 2                       \
\
--verif-text=""                     \
--wrong-text=""                     \
