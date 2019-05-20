#!/usr/bin/env bash

while read -r F
do
    # shellcheck disable=SC2001
    STRIPPED=$(echo "$F" | sed -e 's/-[^ ()]*\.\(....*\)/.\1/g')

           F_ESC=$(echo "$F"        | esc.sh)
    STRIPPED_ESC=$(echo "$STRIPPED" | esc.sh)

    echo "mv '$F_ESC' '$STRIPPED_ESC'"
done < <(find Music/Commercial -type f | grep -- '-[^ ]*\....[.]*')
