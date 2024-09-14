#!/usr/bin/env bash

BOOKMARKS_PATH="$XDG_DATA_HOME/bookmarks/bookmarks"
CACHEFILE="$XDG_CACHE_HOME/mpv-youtube.last"
LASTENTRY=$(< "$CACHEFILE")
VIDEOUNAVAILABLE="$XDG_DATA_HOME/youtube-video-unavailable.mp4"

ENTRY=$(cat <(printf 'Last: %s\n\n' "$LASTENTRY") <(grep -E "https?://(www\.)?youtube\.(com|de)" "$BOOKMARKS_PATH" | sort -r | awk '{tmp=$1; $1=""; print $0 " " tmp }') | dmenu -p "YouTube Bookmarks:" -i -l 30)
if [ -z "$ENTRY" ]; then
	exit 0
else
	echo "$ENTRY" > "$CACHEFILE"
fi
LINK=$(echo "$ENTRY" | tr ' ' '\n' | tail -1)
[ -z "$LINK" ] || mpv --no-terminal --force-window --keep-open=yes --ytdl --x11-name="mpv-youtube" "$LINK"
if [ $? == "2" ]; then
	mpv --no-terminal --force-window --keep-open=yes --no-osc --x11-name="mpv-youtube" --loop=inf "$VIDEOUNAVAILABLE"
fi
