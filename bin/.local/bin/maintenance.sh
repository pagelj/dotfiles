#!/bin/dash

echo ''
echo '########################################################'
echo '################ systemctl --failed ####################'
echo '########################################################'
echo ''
systemctl --failed
echo ''
echo '########################################################'
echo '################ journalctl -p 0 -xb ###################'
echo '########################################################'
echo ''
journalctl -p 0 -xb
echo ''
echo '#########################################################'
echo '################ journalctl -p 1 -xb ####################'
echo '#########################################################'
echo ''
journalctl -p 1 -xb
echo ''
echo '#########################################################'
echo '################ journalctl -p 2 -xb ####################'
echo '#########################################################'
echo ''
journalctl -p 2 -xb
echo ''
echo '#########################################################'
echo '################ journalctl -p 3 -xb ####################'
echo '#########################################################'
echo ''
journalctl -p 3 -xb
echo ''
echo '#########################################################'
echo '################ journalctl -xb | grep -i ufw ###########'
echo '#########################################################'
echo ''
journalctl -xb | grep -i ufw
echo ''
echo '#########################################################'
echo '################ find ~ -xtype l -print ##################'
echo '#########################################################'
echo ''
find ~ -xtype l -print
echo ''
echo '#########################################################'
echo '### pacman -Qqen > /root/pacman/pkglist.txt #############'
echo '#########################################################'
echo ''
pacman -Qqen > /root/pacman/pkglist.txt
echo 'Saved package list to /root/pacman/pkglist.txt'
echo ''
echo '#########################################################'
echo '### pacman -Qqem > /home/pagel/.pacman/pkglist_aur.txt ##'
echo '#########################################################'
echo ''
pacman -Qqem > /root/pacman/pkglist_aur.txt
echo 'Saved aur package list to /root/pacman/pkglist_aur.txt'
echo ''
echo '#########################################################'
echo '################ paccache -rvk 2 ########################'
echo '#########################################################'
echo ''
paccache -r -v -k 2
echo ''
echo '##########################################################################################'
echo '####### reflector --verbose -l 15 --sort rate --save /etc/pacman.d/mirrorlist #############'
echo '##########################################################################################'
echo ''
reflector --verbose -l 15 --sort rate --save /etc/pacman.d/mirrorlist
echo ''
