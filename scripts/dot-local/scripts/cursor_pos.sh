#!/bin/sh

echo -ne "\033[6n"            # ask the terminal for the position
read -s -d\[ garbage          # discard the first part of the response
read -s -d R pos              # store the position in bash variable 'pos'
echo "Cursor position: $pos"  # print the position
unset pos                     # free variable 'pos'
