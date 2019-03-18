#!/bin/sh

st -e watch -n 0.1 -t 'for i in `ip r`; do echo $i; done | grep -A 1 src | tail -1 | cowsay && dig +short myip.opendns.com @resolver1.opendns.com | cowthink; if [ -d "/proc/sys/net/ipv4/conf/tun0" ]; then cowsay -p VPN; fi'
