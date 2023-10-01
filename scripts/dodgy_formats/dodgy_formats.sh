#!/usr/bin/env bash
set -e

function checkDir {
    find "$1" -iname "*.aac" -type f | while read -r F
    do
        echo "AAC file '$F' is hard to tag, try getting an Opus"
    done

    find "$1" -iname "*.wma" -type f | while read -r F
    do
        echo "WMA file '$F' is a shitty format, try getting an Opus"
    done
}

if [[ "$#" -gt 0 ]]
then
    for DIR in "$@"
    do
        [[ -d "$DIR" ]] || {
            echo "Given '$DIR' isn't a directory, skipping" 1>&2
            continue
        }
    done
else
    for ARTIST in Music/Commercial/*/*
    do
        [[ -d "$ARTIST" ]] || continue
        checkDir "$ARTIST"
    done
fi
exit 0
