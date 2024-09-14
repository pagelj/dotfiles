#!/usr/bin/env dash

find "$XDG_DATA_HOME"/vimwiki/pdf/note-*.pdf | tac | head -n1 | xargs zathura
