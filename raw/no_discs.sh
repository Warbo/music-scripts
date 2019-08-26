#!/usr/bin/env bash

# Try to get rid of things like "(Disc 1)" in directory names, as they just
# lead to duplicates

function checkArtist {
    for ALBUM in "$1"/*
    do
        [[ -d "$ALBUM" ]] || continue

        NAME=$(basename "$ALBUM")
        if echo "$NAME" | grep -i disc > /dev/null
        then
            echo "'$ALBUM' may be disc-specific album"
        fi

        # Skip dodgy chars
        convmv -f utf8 -t utf8 "$NAME" > /dev/null 2> /dev/null || continue

         NODISC=$(echo "$NAME"   | rev | cut -c 10- | rev)
          LOWER=$(echo "$NAME"   | tr '[:upper:]' '[:lower:]')
        NOLOWER=$(echo "$NODISC" | tr '[:upper:]' '[:lower:]')
        for DISC in 1 2 3 4 5
        do
            if [[ "x${NOLOWER} (disc ${DISC})" = "x$LOWER" ]]
            then
                DIR=$(dirname "$ALBUM")
                pushd "$DIR" > /dev/null || exit 1
                mkdir -p "$NODISC"
                for TRACK in "$NAME"/*
                do
                    move_command "$PWD/$TRACK" "$PWD/$NODISC/"
                done
                popd > /dev/null || exit 1
            fi
        done
    done
}

if [[ "$#" -eq 0 ]]
then
    for LETTER in Music/Commercial/*
    do
        [[ -d "$LETTER" ]] || continue
        for ARTIST in "$LETTER"/*
        do
            checkArtist "$ARTIST"
        done
    done
else
    for D in "$@"
    do
        checkArtist "$D"
    done
fi
