#!/usr/bin/env bash

function go {
    while read -r F
    do
        # shellcheck disable=SC2001
        STRIPPED=$(echo "$F" | sed -e 's/-[^ ()]*\.\(....*\)/.\1/g')

        # Some files have the track number followed by a dash; these should be
        # left alone
        REMAINING=$(basename "$STRIPPED" | rev | cut -d '.' -f2- | rev)
        echo "$REMAINING" | grep '^[0-9]*$' > /dev/null && continue

               F_ESC=$(echo "$F"        | esc)
        STRIPPED_ESC=$(echo "$STRIPPED" | esc)

        echo "mv '$F_ESC' '$STRIPPED_ESC'"
    done < <(find "$1" -type f | grep -- '-[^ ]*\....[.]*')
}

if [[ "$#" -eq 0 ]]
then
    go Music/Commercial
else
    for D in "$@"
    do
        go "$D"
    done
fi
