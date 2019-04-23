#!/usr/bin/env bash

TAG="$1"
VAL="$2"

function setTag() {
    NAME=$(basename "$1" | sed -e 's/"/\"/g')
     DIR=$(dirname  "$1")

    # shellcheck disable=SC2154
    GOT=$("$xvfb" kid3-cli -c 'select "'"$NAME"'"'        \
                           -c 'set "'"$TAG"'" "'"$VAL"'"' \
                           -c 'save' "$DIR" 2>&1)

    if echo "$GOT" | grep 'Error while writing file' 1>&2
    then
        exit 1
    fi
}

shift
shift

for ARG in "$@"
do
    setTag "$ARG"
done
