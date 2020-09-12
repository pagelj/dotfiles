#!/bin/bash

# Replace characters recursively
# Changes every occurence of $sourcechar with $targetchar
#####################################

> /tmp/rmspaces_tmp.txt

echo "0" > /tmp/rmspaces_tmp.txt

if [ -z $1 ];then echo Give target directory; exit 0;fi

change_counter=0

# define what character should be changed
# to what other character
sourcechar=' '
targetchar='_'


find "$1" -depth -name '*' | while read file ; do
        directory=$(dirname "$file")
        oldfilename=$(basename "$file")
        newfilename=$(echo "$oldfilename" | tr "$sourcechar" "$targetchar")
        if [ "$oldfilename" != "$newfilename" ]; 

	then

            mv -i "$directory/$oldfilename" "$directory/$newfilename"
            echo ""$directory/$oldfilename" ---> "$directory/$newfilename""

	    change_counter=$(($change_counter+1))

	    echo "$change_counter" > /tmp/rmspaces_tmp.txt

            #echo "$directory"
            #echo "$oldfilename"
            #echo "$newfilename"
	    #echo

        fi
        done

change_counter=$(</tmp/rmspaces_tmp.txt)

if [ $change_counter -eq 0 ];

then

    echo "No files have to be renamed."

else

    if [ $change_counter -eq 1 ];

    then

	echo ""$change_counter" file was renamed."

    else

	echo ""$change_counter" files were renamed."

    fi

fi

rm /tmp/rmspaces_tmp.txt

echo "Done."

exit 0
