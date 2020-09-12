#!/bin/env bash

BOOKMARKS_HTML="$HOME/.bookmarks.html"
BOOKMARKS_TXT="$HOME/.bookmarks"

paste -d' ' <(pup -f $BOOKMARKS_HTML "dt a attr{adddate}") <(pup -f $BOOKMARKS_HTML "dt a attr{href}") <(pup -f $BOOKMARKS_HTML "dt a text{}") | sort | cut -d' ' -f 2- > $BOOKMARKS_TXT
