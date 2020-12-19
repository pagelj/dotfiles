#!/bin/dash

find "$HOME"/.local/build/aur -mindepth 1 -maxdepth 1 -type d -printf \\n%f\\n -execdir git -C {} pull \;
