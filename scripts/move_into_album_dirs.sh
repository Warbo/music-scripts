#!/usr/bin/env bash

function same {
    X=$(echo "$1" | tr -dc '[:alnum:]' | tr '[:upper:]' '[:lower:]')
    Y=$(echo "$2" | tr -dc '[:alnum:]' | tr '[:upper:]' '[:lower:]')
    if [[ "x$X" = "x$Y" ]]
    then
        return 0
    fi
    return 1
}

TOP=$(readlink -f "Music/Commercial")

function processDir {
    DIR=$(readlink -f "$1")
    echo "$DIR" | grep "^$TOP/" > /dev/null || {
        echo "Given dir '$DIR' doesn't begin with '$TOP'" 1>&2
        exit 1
    }

      BITS=$(echo "$DIR"  | sed  -e "s@^$TOP/@@g" | tr '/' '\n')
    ARTIST=$(echo "$BITS" | head -n2 | tail -n1)

    [[ -n "$INIT" ]] || INIT=$(echo "$ARTIST" | cut -c1)

    [[ -d "$TOP/$INIT" ]] || {
        echo "No dir '$TOP/$INIT'" 1>&2
        exit 1
    }

    [[ -d "$TOP/$INIT/$ARTIST" ]] || {
        echo "No dir '$TOP/$INIT/$ARTIST'" 1>&2
        exit 1
    }

    while read -r F
    do
        ALBUM=$(get_tag album "$F") || continue
        [[ -n "$ALBUM" ]] || continue

        D=$(dirname "$(readlink -f "$F")")
        same "$D" "$TOP/$INIT/$ARTIST/$ALBUM" || {
            EF=$(echo "$F"                        | esc)
            EP=$(echo "$TOP/$INIT/$ARTIST/$ALBUM" | esc)

            echo "File '$F' has album '$ALBUM'; move with command:"
            echo "mkdir -p '$EP'"
            echo "mv '$EF' '$EP/'"
        }
    done < <(find "$DIR" -type f)
}

if [[ -n "$1" ]]
then
    processDir "$1"
else
    for I in Music/Commercial/*
    do
        [[ -d "$I" ]] || continue
        INIT=$(basename "$I")
        for A in "$I"/*
        do
            [[ -d "$A" ]] || continue
            processDir "$A"
        done
    done
fi
