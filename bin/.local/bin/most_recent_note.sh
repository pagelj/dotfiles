#!/bin/sh

ls -r $XDG_DATA_HOME/vimwiki/pdf/note-*.pdf | head -n1 | xargs zathura
