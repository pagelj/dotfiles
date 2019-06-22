#!/bin/dash

if [ $(amixer get Master | tail -1 | awk '{ print $6 " " }' | tr -d '[' | tr -d ']') = 'on' ]
then
	VOL="$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')"
elif [ $(amixer get Master | tail -1 | awk '{ print $6 " " }' | tr -d '[' | tr -d ']') = 'off' ]
then
	VOL="muted"
fi
LOCALTIME=$(date +%Z%Y-%m-%dW%V%a%H:%M:%S)
UTC=$(TZ=UTC date +%Z%Y-%m-%dW%V%a%H:%M:%S)
IP="$(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1)"
if [ -d "/proc/sys/net/ipv4/conf/tun0" ]
then
	VPN="yes"
else
	VPN="no"
fi
TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))°C"
BAT="$(acpi -b | awk '{ print $4 " " }' | tr -d ',' | tr -d ' ')"
CURRENT_SONG="$(mpc --format "[[%composer%|%artist%][ - %album%][ - %title%] | [%file%]]" current)"

echo "LOCALTIME = $LOCALTIME\nVOL = $VOL\nIP = $IP\nVPN = $VPN\nTEMP = $TEMP\nBAT = $BAT\nUTC = $UTC\nSONG = $CURRENT_SONG" | dmenu -p System\ Info: -l 8 -fn "Sans:size=11"
