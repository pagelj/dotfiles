#!/bin/dash

st -e watch -n 0.1 -t 'for i in `ip r`; do echo $i; done | grep -A 1 src | tail -1 | cowsay -f tux; if [ -d "/proc/sys/net/ipv4/conf/tun0" ]; then nordvpn status | cowsay -n -b -f tux && nordvpn settings | cowsay -n -b -f tux; else cowsay -p -f tux no VPN; fi'
