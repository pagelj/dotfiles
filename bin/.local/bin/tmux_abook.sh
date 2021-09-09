#!/usr/bin/env dash

tmux new-window abook --config "$XDG_CONFIG_HOME"/abook/abookrc --datafile "$XDG_DATA_HOME"/abook/addressbook && tmux rename-window abook
