#!/usr/bin/env bash

DIR="$1"
[[ -n "$DIR" ]] || DIR="Music"

PREFIXED=0

while read -r P
do
    [[ -n "$P" ]] || continue
    if [[ "$PREFIXED" -eq 0 ]]
    then
        PREFIXED=1
        echo "Found crap you might want to delete" 1>&2
    fi
    echo "$P"
done < <(find "$DIR" -iname "*.db"      \
                 -or -iname "*.jpg"     \
                 -or -iname "*.jpeg"    \
                 -or -iname "*.png"     \
                 -or -iname "*.url"     \
                 -or -iname "*.txt"     \
                 -or -iname "*.ini"     \
                 -or -iname "*.onetoc2" \
                 -or -iname "*.htm"     \
                 -or -iname "*.html")
