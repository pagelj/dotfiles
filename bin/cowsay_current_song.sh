#!/bin/dash

st -e watch -n 0.1 -t 'mpc --format "[%composer%|%artist%][ - %album%][ - %title%]" | cowsay -n'
