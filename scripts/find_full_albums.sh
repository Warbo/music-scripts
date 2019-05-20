#!/usr/bin/env bash

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
