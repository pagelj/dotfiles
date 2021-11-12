#!/usr/bin/env dash

tmux new-window nvim -c ":VimwikiIndex" && tmux rename-window vimwiki
