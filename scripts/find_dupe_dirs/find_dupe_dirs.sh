#!/usr/bin/env bash

# Run `guess_dupes` on all directories found inside each artist directory. This
# is useful for finding duplicate album directories.

function go {
    # Look for directories which appear to be the same (e.g. differing only in
    # punctuation)
    while read -r PAIR
    do
         FIRST=$(echo "$PAIR" | cut -f1)
        SECOND=$(echo "$PAIR" | cut -f2)

        # Avoid empty or otherwise dodgy paths
        echo "$FIRST"  | grep 'Music/' > /dev/null || continue
        echo "$SECOND" | grep 'Music/' > /dev/null || continue

        echo "Directory '$FIRST' looks like '$SECOND'; move contents with:"
        move_command "$FIRST" "$SECOND/" "/*"
        echo "rmdir '$(echo "$FIRST" | esc)'"

        # We limit ourselves to directories (i.e. albums). We use "tail" to
        # remove the first line, since that will be the artist name, which would
        # get flagged as a dupe if they have a self-titled album or something.
    done < <(find "$1" -type d | tail -n+2 | list_dupe_guesses.sh)
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
