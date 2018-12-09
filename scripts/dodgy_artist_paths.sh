#!/usr/bin/env bash

function checkArtist() {
    NAME=$(basename "$1")

    if echo "$NAME" | grep '^.\.\(.\.\)*.$' > /dev/null
    then
        echo "'$1' should probably end in a '.'"
    fi

    if echo "$NAME" | grep ', The' > /dev/null
    then
        echo "'$1' should probably be 'The ...'"
    fi
}

function findBad() {
    NAME=$(basename "$1")
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
}

if [[ -n "$1" ]]
then
    BADDIR="$1"
    BADNUM=1
    for ARTIST in "$1"/*
    do
        checkArtist "$ARTIST"
    done
else
    BADDIR='Music/Commercial/'
    BADNUM=2
    for ARTIST in Music/Commercial/*/*
    do
        checkArtist "$ARTIST"
    done
fi

find "$BADDIR" -maxdepth "$BADNUM" | while read -r P
do
    findBad "$P"
done
