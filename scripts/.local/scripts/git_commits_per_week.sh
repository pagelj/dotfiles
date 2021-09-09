#!/usr/bin/env dash

# Requires `dateutils` package to be installed
TZ=$(date +%z) git log --reverse --date-order --format="%cd" --date=iso-local \
  | dateround -S Sun \
  | cut -d'T' -f1 \
  | uniq -c \
  | column -t \
  | perl -pwe 's{\s+}{\t}'
