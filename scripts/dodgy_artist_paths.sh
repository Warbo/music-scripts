#!/usr/bin/env bash

for ARTIST in Music/Commercial/*/*
do
    NAME=$(basename "$ARTIST")

    if echo "$NAME" | grep '^.\.\(.\.\)*.$' > /dev/null
    then
        echo "'$NAME' should probably end in a '.'"
    fi

    if echo "$NAME" | grep ', The' > /dev/null
    then
        echo "'$NAME' should probably be 'The ...'"
    fi
done

find Music/Commercial/ -maxdepth 2 | while read -r P
do
    NAME=$(basename "$P")
    for ARTIST in Blue\ Oyster\ Cult  \
                      Blue\ Oeyster\ Cult \
                      Motvrhead           \
                      Motorhead           \
                      Motoerhead
    do
        if [[ "x$NAME" = "x$ARTIST" ]]
        then
            echo "Found badly named '$NAME' directory"
        fi
    done
done
