#!/bin/sh

# Customize tmux's {pane_current_path} variable

if [ $1 = $HOME ]; then
	echo "~/"
elif [ $1 = "/" ]; then
	echo "/"
else
	echo $(basename $1)/
fi
