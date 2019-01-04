#!/bin/bash -x

xset +fp /usr/share/fonts/local
xset fp rehash

xset -b # disable system bell

eval `/usr/bin/ssh-agent`
if test -f /usr/lib/openssh/x11-ssh-askpass
then
	SSH_ASKPASS=/usr/lib/openssh/x11-ssh-askpass ssh-add < /dev/null
fi

xrdb -merge ~/.Xresources # Read Xresources
xmodmap ~/.Xmodmap
setxkbmap -layout de # Set keyboard layout
sh ~/.fehbg & # Set wallpaper
xbindkeys # Use cumstomized keybindings
xbacklight -set 40 # Dim screen

# Autostart
xautolock -time 30 -locker slock & # Automatic screen lock
clipmenud & # Nice clipboard using dmenu
pgrep redshift &> /dev/null || redshift -l 48:9 &> /dev/null & # For dimmed display at night
xcompmgr & # start composition manager
nohup mons -a > /dev/null 2>&1 & # Re-establishs the display if it detects only one monitor

# Set window/desktop manager
exec dwm
#exec i3
#exec qtile
