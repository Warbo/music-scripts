#!/usr/bin/env bash

for F in Music/Commercial/0-9/*
do
    [[ -f "$F" ]] || {
        echo "Skipping non-file '$F'" 1>&2
        continue
    }

    echo "Looking for artist tag in '$F'" 1>&2
    ARTIST=$(get_tag artist "$F")

    [[ -n "$ARTIST" ]] || {
        echo "No artist tag for '$F', skipping" 1>&2
        continue
    }

    ARTIST_ESC=$(echo "$ARTIST" | esc)
    INIT=$(echo "$ARTIST" | cut -c1)

    [[ -d Music/Commercial/"$INIT" ]] || {
        echo "Initial '$INIT' doesn't have directory in Music/Commercial" 1>&2
        continue
    }

    [[ -d Music/Commercial/"$INIT"/"$ARTIST" ]] || {
        echo "No directory for '$ARTIST'" 1>&2
        echo "mkdir 'Music/Commercial/$INIT/$ARTIST_ESC'"
        continue
    }

    echo "Looking for album tag in '$F'" 1>&2
    ALBUM=$(get_tag album "$F")

    if [[ -n "$ALBUM" ]]
    then
        echo "Found album tag '$ALBUM'" 1>&2
        ALBUM_ESC=$(echo "$ALBUM" | esc)

        if [[ -d Music/Commercial/"$INIT"/"$ARTIST"/"$ALBUM" ]]
        then
            echo "Found album dir '$ALBUM'" 1>&2
            move_command "$F" "Music/Commercial/$INIT/$ARTIST/$ALBUM/"
        else
            echo "No album dir for '$ALBUM'" 1>&2
            echo "mkdir 'Music/Commercial/$INIT/$ARTIST_ESC/$ALBUM_ESC'"

            echo "To ignore the album, just run" 1>&2
            move_command "$F" "Music/Commercial/$INIT/$ARTIST/"
        fi
    else
        echo "No album tag for '$F'" 1>&2
        move_command "$F" "Music/Commercial/$INIT/$ARTIST/"
    fi
done
