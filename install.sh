#!/usr/bin/env sh

XDG_DATA_HOME="$HOME"/.local/share

stow abook
stow autostart
stow bin
stow dunst
stow emacs
stow gnupg
stow mime
mkdir -p "$XDG_DATA_HOME"/mpd
mkdir -p "$XDG_DATA_HOME"/mpd/playlists
mkdir -p "$XDG_DATA_HOME"/mpd/database
stow mpd
stow ncmpcpp
stow newsboat
stow nvim
stow python
stow scripts
stow snippets
stow suckless
stow sxhkd
stow systemd
stow task
stow tmux
stow top
stow xinit
stow zathura
mkdir -p "$XDG_DATA_HOME"/zsh
stow zsh
