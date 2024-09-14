#!/bin/bash

# script for showing current directory in tmux

#tmux showenv -g TMUX_PWD_$(tmux display -p "#D" | tr -d %)  | sed 's/^.*=//'
# pretty shitty to get the last element of the sed output by double reversing, but it works
tmux showenv -g TMUX_PWD_$(tmux display -p "#D" | tr -d %) | sed 's/^.*=//' | rev | cut -d'/' -f 1 | rev | awk '{print $1"/"}'
