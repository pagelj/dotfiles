#!/usr/bin/env dash

tmux new-window "inxi -BDjms --force colors | less" && tmux rename-window info
