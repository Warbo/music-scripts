#!/usr/bin/env bash

for INIT in Music/Commercial/*
do
    [[ -d "$INIT" ]] || {
        echo "Warning: '$INIT' is not a directory" >> /dev/stderr
        continue
    }
    for ARTIST in "$INIT"/*
    do
        [[ -d "$ARTIST" ]] || {
            echo "Warning: '$ARTIST' is not a directory" >> /dev/stderr
            continue
        }
        while read -r PAIR
        do
             FIRST=$(echo "$PAIR" | cut -f1 | esc.sh)
            SECOND=$(echo "$PAIR" | cut -f2 | esc.sh)

            echo "mv '$FIRST'/* '$SECOND'/"
        done < <(find "$ARTIST" -type d | list_dupe_guesses.sh)
    done
done
