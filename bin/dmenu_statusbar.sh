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
PUBIP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
if [ -d "/proc/sys/net/ipv4/conf/tun0" ]
then
	VPN="yes"
else
	VPN="no"
fi
TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))°C"
BAT="$(acpi -b | awk '{ print $4 " " }' | tr -d ',' | tr -d ' ')"

echo -e "time=$LOCALTIME\nvol=$VOL\nip=$IP\npubip=$PUBIP\nvpn=$VPN\ntemp=$TEMP\nbat=$BAT\nutc=$UTC" | dmenu -fn "Sans:size=11"
