#!/usr/bin/env bash

function go {
    while read -r F
    do
        # shellcheck disable=SC2001
        STRIPPED=$(echo "$F" | sed -e 's/-[^ ()]*\.\(....*\)/.\1/g')

               F_ESC=$(echo "$F"        | esc.sh)
        STRIPPED_ESC=$(echo "$STRIPPED" | esc.sh)

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
