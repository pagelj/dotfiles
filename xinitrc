#!/bin/bash -x

xset +fp /usr/share/fonts/local
xset fp rehash

xset -b # disable system bell

eval `/usr/bin/ssh-agent`
if test -f /usr/lib/openssh/x11-ssh-askpass
then
	SSH_ASKPASS=/usr/lib/openssh/x11-ssh-askpass ssh-add < /dev/null
fi

xrdb -merge ~/.Xresources
xmodmap ~/.Xmodmap
setxkbmap -layout de # Set keyboard layout
sh ~/.fehbg & # Set wallpaper
xbindkeys # Use cumstomized keybindings

# Autostart
xautolock -time 30 -locker slock & # Automatic screen lock
clipmenud & # Nice clipboard using dmenu
pgrep redshift &> /dev/null || redshift -l 48:9 &> /dev/null & # For dimmed display at night
xcompmgr & # start composition manager
nohup mons -a > /dev/null 2>&1 & # Re-establishs the display if it detects only one monitor

# Set status line for dwm
while true
do
        if [ $(amixer get Master | tail -1 | awk '{ print $6 " " }' | tr -d '[' | tr -d ']') = 'on' ]
        then
	    VOL="Vol=$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')"
	elif [ $(amixer get Master | tail -1 | awk '{ print $6 " " }' | tr -d '[' | tr -d ']') = 'off' ]
	then
	    VOL="Vol=muted"
	fi
	LOCALTIME=$(TZ=Europe/Berlin date +%Z\=%Y-%m-%dW%V%a%H:%M:%S)
	UTC="("$(TZ=UTC date +%Z\=%Y-%m-%dW%V%a%H:%M:%S)")"
	IP="IP=$(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1)"
	if [ $(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000)) -ge 100 ]
	then
	    TEMP="Temp=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))°C"
        else
	    TEMP=""
	fi
	VERSION=$(echo 'dwm-6.1') # dwm -v does not work :(
	if [ "$(acpi -b | awk '{ print $3 " " }' | tr -d ',' | tr -d ' ')" != "Full" ]
	then
	    BAT="Bat=$(acpi -b | awk '{ print $4 " " }' | tr -d ',' | tr -d ' ')"
	else
	    BAT=""
	fi
	xsetroot -name "$IP $VOL $BAT $TEMP $LOCALTIME $VERSION"
	sleep 0.1s
done &

# Set window/desktop manager
exec dwm
#exec i3
#exec qtile
