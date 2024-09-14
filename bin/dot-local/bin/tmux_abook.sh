#!/usr/bin/env dash

tmux new-window -n abook abook --config "$XDG_CONFIG_HOME"/abook/abookrc --datafile "$XDG_DATA_HOME"/abook/addressbook
