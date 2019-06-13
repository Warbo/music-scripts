#!/usr/bin/env bash

function go {
    echo "Looking for dupes in '$1'" 1>&2
    DUPES=$(find "$1" -type f | guess_dupes)
    echo "Possible dupes:"
    echo "$DUPES"
    echo "Checking CRCs"   1>&2
    echo "$DUPES" | grep -n "looks like" | while read -r LINE
    do
          NUM=$(echo "$LINE"  | cut  -d ':' -f1)
        AFTER=$(echo "$DUPES" | tail -n +"$NUM")
          END=$(echo "$AFTER" | grep -n "^END$" | cut -d ':' -f1 | head -n1)
        TRACK=$(echo "$LINE"  | sed  -e 's/ looks like://g' | cut -d ':' -f 2-)

        echo "$AFTER" | head -n "$END" |
            grep -v "looks like:"      |
            grep -v "^END$"            | while read -r NAME
        do
            echo "COMPARE	$TRACK	$NAME"
        done
    done | compare_crcs
}

# Look for similar filenames inside artist directories
if [[ "$#" -gt 0 ]]
then
    go "$1"
else
    for INIT in Music/Commercial/*
    do
        [[ -d "$INIT" ]] || continue
        for ARTIST in "$INIT"/*
        do
            [[ -d "$ARTIST" ]] || continue
            go "$ARTIST"
        done
    done
fi
