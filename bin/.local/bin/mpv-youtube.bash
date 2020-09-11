#!/bin/env bash

BOOKMARKS_PATH="$HOME/.bookmarks.html"
CACHEFILE=$HOME/.cache/mpv-youtube.last
LASTENTRY=`< $CACHEFILE`

ENTRY=$(cat <(printf 'Last: %s\n\n' "$LASTENTRY") <(paste -d' ' <(pup -f $BOOKMARKS_PATH "dt a attr{adddate}") <(pup -f $BOOKMARKS_PATH "dt a text{}") <(pup -f $BOOKMARKS_PATH "dt a attr{href}") | egrep "https?://(www\.)?youtube\.(com|de)" | sort -r | cut -d' ' -f2-) | dmenu -p "YouTube Bookmarks:" -i -l 30)
if [ -z "$ENTRY" ]; then
	exit 0
else
	echo $ENTRY > $CACHEFILE
fi
LINK=$(echo $ENTRY | tr ' ' '\n' | tail -1)
mpv --no-terminal --force-window --keep-open=yes --ytdl --no-osc --x11-name="mpv-youtube" "$LINK"
