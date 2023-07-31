#!/usr/bin/env sh

XDG_DATA_HOME="$HOME"/.local/share

stow abook
stow autostart
stow bin
stow dunst
stow emacs
stow gnupg
stow mime
mkdir -p "$XDG_DATA_HOME"/mpd/playlists
mkdir -p "$XDG_CACHE_HOME"/mpd
stow mpd
stow ncmpcpp
stow newsboat
stow nvim
stow python
stow scripts
stow snippets
#stow suckless
mkdir -p "$XDG_CONFIG_HOME"/surfraw/elvi
ln ./surfraw/.config/surfraw/elvi/currency "$XDG_CONFIG_HOME"/surfraw/elvi/currency
ln ./surfraw/.config/surfraw/elvi/dictcc "$XDG_CONFIG_HOME"/surfraw/elvi/dictcc
ln ./surfraw/.config/surfraw/elvi/duckduckgo "$XDG_CONFIG_HOME"/surfraw/elvi/duckduckgo
ln ./surfraw/.config/surfraw/elvi/searx "$XDG_CONFIG_HOME"/surfraw/elvi/searx
stow sxhkd
stow systemd
stow task
stow tmux
stow top
stow vim
stow xinit
stow ytfzf
stow zathura
mkdir -p "$XDG_DATA_HOME"/zsh
stow zsh
