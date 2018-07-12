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
sh ~/.fehbg & # Set background image
xbindkeys # Use cumstomized keybindings

# Autostart
xautolock -time 30 -locker slock & # Automatic screen lock
clipmenud & # Nice clipboard using dmenu
pgrep redshift &> /dev/null || redshift -l 48:9 &> /dev/null & # For dimmed display at night
compton -bCG & # start compton
nohup mons -a > /dev/null 2>&1 & # Re-establishs the display if it detects only one monitor
#if tmux info &> /dev/null; then # if tmux server already running, attach to current session
#   hash st && st -e tmux a &
#else
#   hash st && st -e tmux &
#fi

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
	TEMP="Temp=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))°C"
	VERSION=$(echo 'dwm-6.1') # dwm -v does not work :(
	BAT="Bat=$(acpi -b | awk '{ print $4 " " }' | tr -d ',' | tr -d ' ')"

	xsetroot -name "$IP $VOL $BAT $TEMP $LOCALTIME $VERSION"
	sleep 1s
done &

# Call conky depending on window manager
#conky -b -c ~/.conky/.conkyrc_i3 && conky -b -c ~/.conky/.conkyrc_tmux && conky -b -c ~/.conky/.conkyrc_vim &
conky -b -c ~/.conky/.conkyrc_dwm && conky -b -c ~/.conky/.conkyrc_tmux && conky -b -c ~/.conky/.conkyrc_vim & 

# Set window/desktop manager
exec dwm
#exec i3
#exec qtile
