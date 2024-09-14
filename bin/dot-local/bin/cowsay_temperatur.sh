#!/bin/bash

st -e watch -n 0.1 -t $'cat /sys/class/thermal/thermal_zone0/temp | awk \'{ print "thermal_zone0: " $1/1000 "°C" }\' | cowsay -f tux'
