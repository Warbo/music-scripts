#!/usr/bin/env bash

echo "Looking for transcoded files on stdin" 1>&2

FORMATS="ogg mp3 opus wma flac"
while read -r F
do
    for FMT1 in $FORMATS
    do
        for FMT2 in $FORMATS
        do
            if echo "$F" | grep -i "\\.$FMT1\\.$FMT2" > /dev/null
            then
                ORIG=$(basename "$F" ".$FMT2")
                if [[ -e "$ORIG" ]]
                then
                    echo "'$F' seems to be transcoded from '$ORIG'"
                else
                    echo "'$F' seems to be transcoded; rename?"
                fi
            fi
        done
    done
done
