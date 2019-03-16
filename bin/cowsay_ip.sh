#!/bin/sh

st -e watch -n 0.1 -t 'for i in `ip r`; do echo $i; done | grep -A 1 src | tail -1 | cowsay'
