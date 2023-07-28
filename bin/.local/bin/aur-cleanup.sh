#!/usr/bin/env dash

find "$HOME"/.local/build/aur -depth -mindepth 1 -maxdepth 2 \( -type f -name '*.zst' -o -name '*.zip' -o -name '*.gz' -o -name '*.tgz' -o -name '*.bz2' -o -name '*.deb' -o -name '*.asc' -o -name '*.rpm' -o -name '*.tar.xz' \) -delete
