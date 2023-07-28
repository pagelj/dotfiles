#!/bin/env bash

# Convert Firefox-style html bookmarks to plain text.
# Only keeps links with tags for searchability

BOOKMARKS_HTML="$XDG_DATA_HOME/bookmarks/bookmarks.html"
BOOKMARKS_TXT="$XDG_DATA_HOME/bookmarks/bookmarks"

# pup currently doesn't handle certain special characters (like _) in tags or attributes, need to rename them
paste -d' ' <(sed 's/ADD_DATE/ADDDATE/g' "$BOOKMARKS_HTML" | pup "dt a[tags] attr{adddate}") <(pup -f "$BOOKMARKS_HTML" "dt a[tags] attr{href}") <(pup -f "$BOOKMARKS_HTML" "dt a[tags] text{}") <(pup -f "$BOOKMARKS_HTML" "dt a[tags] attr{tags}") | sort -r | cut -d' ' -f 2- > "$BOOKMARKS_TXT"
