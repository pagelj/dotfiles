#!/usr/bin/env dash

#tmux new-window -n fzf-mpd-library -c "$HOME" mpdmenu -f :: -m --layout=reverse --no-sort
tmux display-popup -h 80% -w 80% -E "mpdmenu -f :: -m --layout=reverse --no-sort"
