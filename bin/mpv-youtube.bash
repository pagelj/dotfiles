#!/bin/env bash

BOOKMARKS="$HOME/.bookmarks.html"
TMPFILE=$HOME/.tmp/mpv-youtube.last
LASTENTRY=`< $TMPFILE`

ENTRY=$(cat <(printf 'Last: %s\n\n' "$LASTENTRY") <(paste -d' ' <(pup -f $BOOKMARKS "dt a attr{adddate}") <(pup -f $BOOKMARKS "dt a text{}") <(pup -f $BOOKMARKS "dt a attr{href}") | egrep "https?://(www\.)?youtube\.(com|de)" | sort -r | cut -d' ' -f2-) | dmenu "$@")
if [ -z "$ENTRY" ]; then
	exit 0
else
	echo $ENTRY > $TMPFILE
fi
LINK=$(echo $ENTRY | tr ' ' '\n' | tail -1)
mpv --x11-name mpv-youtube $LINK
