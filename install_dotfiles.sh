#!/bin/sh

# Link dotfiles from git repo to their respective locations using rsync
GIT_REPO=$HOME/repos/dotfiles # Change if local repo location changes

echo "$GIT_REPO/zsh/zshrc --> ~/.zshrc"
rsync -ac --progress $GIT_REPO/zsh/zshrc ~/.zshrc
echo "$GIT_REPO/zsh/zsh_functions --> ~/.zsh_functions"
rsync -ac --progress $GIT_REPO/zsh/zsh_functions ~/.zsh_functions
echo "$GIT_REPO/zsh/zprofile --> ~/.zprofile"
rsync -ac --progress $GIT_REPO/zsh/zprofile ~/.zprofile
echo "$GIT_REPO/zsh/zsh_aliases --> ~/.zsh_aliases"
rsync -ac --progress $GIT_REPO/zsh/zsh_aliases ~/.zsh_aliases

echo "$GIT_REPO/xinitrc --> ~/.xinitrc"
rsync -ac --progress $GIT_REPO/xinitrc ~/.xinitrc
echo "$GIT_REPO/xbindkeysrc --> ~/.xbindkeysrc"
rsync -ac --progress $GIT_REPO/xbindkeysrc ~/.xbindkeysrc

echo "$GIT_REPO/i3/config --> ~/.config/i3/config"
rsync -ac --progress $GIT_REPO/i3/config ~/.config/i3/config
echo "$GIT_REPO/i3status/config --> ~/.config/i3status/config"
rsync -ac --progress $GIT_REPO/i3status/config ~/.config/i3status/config

echo "~/.config/procps/toprc --> $GIT_REPO/toprc"
rsync -ac --progress ~/.config/procps/toprc $GIT_REPO/toprc

echo "$GIT_REPO/Xresources --> ~/.Xresources"
rsync -ac --progress $GIT_REPO/Xresources ~/.Xresources

echo "$GIT_REPO/moc/config --> ~/.moc/config"
rsync -ac --progress $GIT_REPO/moc/config ~/.moc/config
echo "$GIT_REPO/mpd.conf --> ~/.config/mpd/mpd.conf"
rsync -ac --progress $GIT_REPO/mpd.conf ~/.config/mpd/mpd.conf
echo "$GIT_REPO/ncmpcpp/config --> ~/.config/ncmpcpp/config"
rsync -ac --progress $GIT_REPO/ncmpcpp/config ~/.config/ncmpcpp/config

echo "$GIT_REPO/tmux.conf --> ~/.tmux.conf"
rsync -ac --progress $GIT_REPO/tmux.conf ~/.tmux.conf

echo "$GIT_REPO/taskrc --> ~/.taskrc"
rsync -ac --progress $GIT_REPO/taskrc ~/.taskrc

echo "$GIT_REPO/vim/vimrc --> ~/.vimrc"
rsync -ac --progress $GIT_REPO/vim/vimrc ~/.vimrc
echo "$GIT_REPO/vim/colors/obsidian.vim --> ~/.vim/colors/obsidian.vim"
rsync -ac --progress $GIT_REPO/vim/colors/obsidian.vim ~/.vim/colors/obsidian.vim
echo "$GIT_REPO/vim/colors/true-monochrome.vim --> ~/.vim/colors/true-monochrome.vim"
rsync -ac --progress $GIT_REPO/vim/colors/true-monochrome.vim ~/.vim/colors/true-monochrome.vim
echo "$GIT_REPO/vim/colors/solarized.vim --> ~/.vim/colors/solarized.vim"
rsync -ac --progress $GIT_REPO/vim/colors/solarized.vim ~/.vim/colors/solarized.vim
echo "$GIT_REPO/vim/autoload/plug.vim --> ~/.vim/autoload/plug.vim"
rsync -ac --progress $GIT_REPO/vim/autoload/plug.vim ~/.vim/autoload/plug.vim
echo "$GIT_REPO/vim/ftdetect/text.vim --> ~/.vim/ftdetect/text.vim"
rsync -ac --progress $GIT_REPO/vim/ftdetect/text.vim ~/.vim/ftdetect/text.vim
echo "$GIT_REPO/vim/ftdetect/markdown.vim --> ~/.vim/ftdetect/markdown.vim"
rsync -ac --progress $GIT_REPO/vim/ftdetect/markdown.vim ~/.vim/ftdetect/markdown.vim
echo "$GIT_REPO/vim/ftplugin/text.vim --> ~/.vim/ftplugin/text.vim"
rsync -ac --progress $GIT_REPO/vim/ftplugin/text.vim ~/.vim/ftplugin/text.vim
echo "$GIT_REPO/vim/ftplugin/markdown.vim --> ~/.vim/ftplugin/markdown.vim"
rsync -ac --progress $GIT_REPO/vim/ftplugin/markdown.vim ~/.vim/ftplugin/markdown.vim
echo "$GIT_REPO/vim/ftplugin/vimwiki.vim --> ~/.vim/ftplugin/vimwiki.vim"
rsync -ac --progress $GIT_REPO/vim/ftplugin/vimwiki.vim ~/.vim/ftplugin/vimwiki.vim

echo "$GIT_REPO/emacs --> ~/.emacs"
rysnc -ac --progress $GIT_REPO/emacs ~/.emacs

echo "$GIT_REPO/scripts/tmux_pane_current_path.sh --> ~/scripts/tmux_pane_current_path.sh"
rsync -ac --progress $GIT_REPO/scripts/tmux_pane_current_path.sh ~/scripts/tmux_pane_current_path.sh

echo "$GIT_REPO/bin/start_conky_dwm.sh --> ~/bin/start_conky_dwm.sh"
rsync -ac --progress $GIT_REPO/bin/start_conky_dwm.sh ~/bin/start_conky_dwm.sh
echo "$GIT_REPO/bin/start_conky_i3.sh --> ~/bin/start_conky_i3.sh"
rsync -ac --progress $GIT_REPO/bin/start_conky_i3.sh ~/bin/start_conky_i3.sh
echo "$GIT_REPO/bin/mpsyt.sh --> ~/bin/mpsyt.sh"
rsync -ac --progress $GIT_REPO/bin/mpsyt.sh ~/bin/mpsyt.sh
echo "$GIT_REPO/bin/mutt.sh --> ~/bin/mutt.sh"
rsync -ac --progress $GIT_REPO/bin/mutt.sh ~/bin/mutt.sh
echo "$GIT_REPO/bin/top.sh --> ~/bin/top.sh"
rsync -ac --progress $GIT_REPO/bin/top.sh ~/bin/top.sh
echo "$GIT_REPO/bin/dmenu_statusbar --> ~/bin/dmenu_statusbar"
rsync -ac --progress $GIT_REPO/bin/dmenu_statusbar ~/bin/dmenu_statusbar
echo "$GIT_REPO/bin/cowsay_battery.sh --> ~/bin/cowsay_battery.sh"
rsync -ac --progress $GIT_REPO/bin/cowsay_battery.sh ~/bin/cowsay_battery.sh
echo "$GIT_REPO/bin/cowsay_ip.sh --> ~/bin/cowsay_ip.sh"
rsync -ac --progress $GIT_REPO/bin/cowsay_ip.sh ~/bin/cowsay_ip.sh
echo "$GIT_REPO/bin/cowsay_temperatur.sh --> ~/bin/cowsay_temperatur.sh"
rsync -ac --progress $GIT_REPO/bin/cowsay_temperatur.sh ~/bin/cowsay_temperatur.sh
echo "$GIT_REPO/bin/cowsay_volume.sh --> ~/bin/cowsay_volume.sh"
rsync -ac --progress $GIT_REPO/bin/cowsay_volume.sh ~/bin/cowsay_volume.sh
echo "$GIT_REPO/bin/cowsay_current_song.sh --> ~/bin/cowsay_current_song.sh"
rsync -ac --progress $GIT_REPO/bin/cowsay_current_song.sh ~/bin/cowsay_current_song.sh
echo "$GIT_REPO/bin/dmenu_addressbook --> ~/bin/dmenu_addressbook"
rsync -ac --progress $GIT_REPO/bin/dmenu_addressbook ~/bin/dmenu_addressbook

echo "$GIT_REPO/newsboat/config --> ~/.config/newsboat/config"
rsync -ac --progress $GIT_REPO/newsboat/config ~/.config/newsboat/config

echo "$GIT_REPO/suckless/dwm/config.h --> ~/build/suckless/dwm-6.2/config.h"
rsync -ac --progress $GIT_REPO/suckless/dwm/config.h ~/build/suckless/dwm-6.2/config.h
echo "$GIT_REPO/suckless/st/config.h --> ~/build/suckless/st-0.8.1/config.h"
rsync -ac --progress $GIT_REPO/suckless/st/config.h ~/build/suckless/st-0.8.1/config.h
echo "$GIT_REPO/suckless/st/st.info --> ~/build/suckless/st-0.8.1/st.info"
rsync -ac --progress $GIT_REPO/suckless/st/st.info ~/build/suckless/st-0.8.1/st.info
echo "$GIT_REPO/suckless/dmenu/config.h --> ~/build/suckless/dmenu-4.9/config.h"
rsync -ac --progress $GIT_REPO/suckless/dmenu/config.h ~/build/suckless/dmenu-4.9/config.h
echo "$GIT_REPO/suckless/slock/config.h --> ~/build/suckless/slock-1.4/config.h"
rsync -ac --progress $GIT_REPO/suckless/slock/config.h ~/build/suckless/slock-1.4/config.h
echo "$GIT_REPO/suckless/surf/config.h --> ~/build/suckless/surf-2.0/config.h"
rsync -ac --progress $GIT_REPO/suckless/surf/config.h ~/build/suckless/surf-2.0/config.h

echo "$GIT_REPO/systemd/mbsync.service --> ~/.config/systemd/user/mbsync.service"
rsync -ac --progress $GIT_REPO/systemd/mbsync.service ~/.config/systemd/user/mbsync.service
echo "$GIT_REPO/systemd/mbsync.timer --> ~/.config/systemd/user/mbsync.timer"
rsync -ac --progress $GIT_REPO/systemd/mbsync.timer ~/.config/systemd/user/mbsync.timer
