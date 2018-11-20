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

rsync -ac --progress ~/.config/procps/toprc $GIT_REPO/toprc

rsync -ac --progress $GIT_REPO/Xresources ~/.Xresources

rsync -ac --progress $GIT_REPO/moc/config ~/.moc/config

rsync -ac --progress $GIT_REPO/conky/conkyrc_dwm ~/.conky/conkyrc_dwm
rsync -ac --progress $GIT_REPO/conky/conkyrc_i3 ~/.conky/conkyrc_i3
rsync -ac --progress $GIT_REPO/conky/conkyrc_tmux ~/.conky/conkyrc_tmux
rsync -ac --progress $GIT_REPO/conky/conkyrc_vim ~/.conky/conkyrc_vim

rsync -ac --progress $GIT_REPO/tmux.conf ~/.tmux.conf

rsync -ac --progress $GIT_REPO/taskrc ~/.taskrc

rsync -ac --progress $GIT_REPO/vim/vimrc ~/.vimrc
rsync -ac --progress $GIT_REPO/vim/colors/obsidian.vim ~/.vim/colors/obsidian.vim
rsync -ac --progress $GIT_REPO/vim/autoload/plug.vim ~/.vim/autoload/plug.vim
rsync -ac --progress $GIT_REPO/vim/ftdetect/text.vim ~/.vim/ftdetect/text.vim
rsync -ac --progress $GIT_REPO/vim/ftdetect/markdown.vim ~/.vim/ftdetect/markdown.vim
rsync -ac --progress $GIT_REPO/vim/ftplugin/text.vim ~/.vim/ftplugin/text.vim
rsync -ac --progress $GIT_REPO/vim/ftplugin/markdown.vim ~/.vim/ftplugin/markdown.vim
rsync -ac --progress $GIT_REPO/vim/ftplugin/vimwiki.vim ~/.vim/ftplugin/vimwiki.vim

rsync -ac --progress $GIT_REPO/scripts/tmux_pane_current_path.sh ~/scripts/tmux_pane_current_path.sh

rsync -ac --progress $GIT_REPO/bin/start_conky_dwm.sh ~/bin/start_conky_dwm.sh
rsync -ac --progress $GIT_REPO/bin/start_conky_i3.sh ~/bin/start_conky_i3.sh
rsync -ac --progress $GIT_REPO/bin/mpsyt.sh ~/bin/mpsyt.sh
rsync -ac --progress $GIT_REPO/bin/mutt.sh ~/bin/mutt.sh
rsync -ac --progress $GIT_REPO/bin/top.sh ~/bin/top.sh
rsync -ac --progress $GIT_REPO/bin/dmenu_statusbar.sh ~/bin/dmenu_statusbar.sh

rsync -ac --progress $GIT_REPO/suckless/dwm/config.h ~/build/suckless/dwm-6.1/config.h 
rsync -ac --progress $GIT_REPO/suckless/st/config.h ~/build/suckless/st-0.8.1/config.h 
rsync -ac --progress $GIT_REPO/suckless/st/st.info ~/build/suckless/st-0.8.1/st.info
rsync -ac --progress $GIT_REPO/suckless/dmenu/config.h ~/build/suckless/dmenu-4.8/config.h
rsync -ac --progress $GIT_REPO/suckless/slock/config.h ~/build/suckless/slock-1.4/config.h
