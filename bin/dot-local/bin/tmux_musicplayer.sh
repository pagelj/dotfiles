#!/usr/bin/env dash

tmux new-window "$MUSICPLAYER" && tmux rename-window music && tmux split-window -v -l 20% cava && tmux select-pane -U
