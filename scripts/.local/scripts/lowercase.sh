#!/bin/bash


find . -depth -mindepth 1 -exec bash -c '
  for file do
    # adapt the awk command if you wish to rename to something other than lowercase
    newname=$(dirname "$file")/$(basename "$file" | awk "{print tolower(\$0)}")
    if [ "$file" != "$newname" ] ; then
        # the extra step with the temp filename is for case-insensitive filesystems
        if [ ! -e "$newname" ] && [ ! -e "$newname.lcrnm.tmp" ] ; then
           mv -T "$file" "$newname.lcrnm.tmp" && mv -T "$newname.lcrnm.tmp" "$newname" 
        else
           echo "ERROR: Name already exists: $newname"
        fi
    fi    
  done
' sh {} +
