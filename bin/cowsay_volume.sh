#!/bin/dash

st -e watch -n 0.1 -t 'amixer get Master | tail -2 | cowsay'
