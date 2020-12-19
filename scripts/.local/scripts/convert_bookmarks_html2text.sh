#!/bin/env bash

# Convert Firefox-style html bookmarks to plain text

BOOKMARKS_HTML="$XDG_DATA_HOME/bookmarks/bookmarks.html"
BOOKMARKS_TXT="$XDG_DATA_HOME/bookmarks/bookmarks"

paste -d' ' <(pup -f "$BOOKMARKS_HTML" "dt a attr{adddate}") <(pup -f "$BOOKMARKS_HTML" "dt a attr{href}") <(pup -f "$BOOKMARKS_HTML" "dt a text{}") | sort | cut -d' ' -f 2- > "$BOOKMARKS_TXT"
