#!/usr/bin/env bash

function go {
    # Look for directories which appear to be the same (e.g. differing only in
    # punctuation)
    while read -r PAIR
    do
         FIRST=$(echo "$PAIR" | cut -f1 | esc)
        SECOND=$(echo "$PAIR" | cut -f2 | esc)

        # Avoid empty or otherwise dodgy paths
        echo "$FIRST"  | grep 'Music/' > /dev/null || continue
        echo "$SECOND" | grep 'Music/' > /dev/null || continue

        move_command "$FIRST" "$SECOND/" "/*"
    done < <(find "$1" -type d | list_dupe_guesses.sh)
}

if [[ "$#" -eq 0 ]]
then
    for INIT in Music/Commercial/*
    do
        [[ -d "$INIT" ]] || {
            echo "Warning: '$INIT' is not a directory" 1>&2
            continue
        }
        for ARTIST in "$INIT"/*
        do
            [[ -d "$ARTIST" ]] || {
                echo "Warning: '$ARTIST' is not a directory" 1>&2
                continue
            }
            go "$ARTIST"
        done
    done
else
    for DIR in "$@"
    do
        go "$DIR"
    done
fi
