#!/usr/bin/env dash

TZ=$(date +%z) git log --reverse --date-order --format="%cd" --date=iso-local \
	| cut -d- -f1-2 \
	| uniq -c \
	| column -t \
	| perl -pwe 's{\s+}{\t}'
