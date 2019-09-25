#!/usr/bin/env bash

# Look for any file with a name which indicates it's a full album (i.e. one
# large audio file, when we'd prefer a directory of individual tracks).

function go {
    find "$1" -iname '*full*album*' -or -iname '*full*length*'
}

if [[ "$#" -eq 0 ]]
then
    go Music
else
    for DIR in "$@"
    do
        go "$DIR"
    done
fi
