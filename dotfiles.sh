#!/bin/sh

# Link dotfiles from git repo to their respective locations using rsync
GIT_REPO=$HOME/repos/dotfiles/ # Change if local repo location changes

rsync -ac --progress $GIT_REPO/zsh/zshrc ~/.zshrc
rsync -ac --progress $GIT_REPO/zsh/zsh_functions ~/.zsh_functions
rsync -ac --progress $GIT_REPO/zsh/zprofile ~/.zprofile
rsync -ac --progress $GIT_REPO/zsh/zsh_aliases ~/.zsh_aliases

rsync -ac --progress $GIT_REPO/xinitrc ~/.xinitrc

rsync -ac --progress $GIT_REPO/i3/config ~/.config/i3/config
rsync -ac --progress $GIT_REPO/i3status/config ~/.config/i3status/config

rsync -ac --progress $GIT_REPO/Xresources ~/.Xresources

rsync -ac --progress $GIT_REPO/moc/config ~/.moc/config

rsync -ac --progress $GIT_REPO/conky/conkyrc_dwm ~/.conky/.conkyrc_dwm
rsync -ac --progress $GIT_REPO/conky/conkyrc_i3 ~/.conky/.conkyrc_i3
rsync -ac --progress $GIT_REPO/conky/conkyrc_tmux ~/.conky/.conkyrc_tmux
rsync -ac --progress $GIT_REPO/conky/conkyrc_vim ~/.conky/.conkyrc_vim

rsync -ac --progress $GIT_REPO/tmux.conf ~/.tmux.conf

rsync -ac --progress $GIT_REPO/taskrc ~/.taskrc

rsync -ac --progress $GIT_REPO/vimrc ~/.vimrc
