#!/bin/bash

# Script for converting all files in music library from flac to mp3 and write
# to folder for cell phone transfer
find ~/music -type f -iname "*.flac" -exec sh -c \
'bn=${1##*/}; bn=${bn%.*}; ffmpeg -loglevel 16 -n -i "$1" "${0}${bn}.mp3"' ~/cell/music/ {} \;
