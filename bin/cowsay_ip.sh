#!/bin/sh

st -e watch -n 0.1 -t 'for i in `ip r`; do echo $i; done | grep -A 1 src | tail -1 | cowsay; if [ -d "/proc/sys/net/ipv4/conf/tun0" ]; then cowsay -b VPN; else cowsay -p no VPN; fi'