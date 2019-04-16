#!/usr/bin/env bash

function withExtIn() {
    # Looks for files in $2 which end in extension $1; returns the paths but
    # strips off the extension (so we can stick a new one on)
    while read -r F
    do
        echo "$(dirname "$F")/$(basename "$F" ".$1")"
    done < <(find "$2" -iname "*.$1")
}

function checkFilesIn {
    while read -r F
    do
        F_ESC=$(echo "$F" | esc.sh)
        echo "Found dodgy whitespace in filename '$F_ESC'"
    done < <(find "$1" -iname ' *';
             find "$1" -iname '* ';
             find "$1" -iname ' *.*')

    while read -r F
    do
        F_ESC=$(echo "$F" | esc.sh)
        echo "'$F_ESC' should probably be (losslessly) converted to ogg"
    done < <(find "$1" -iname "*.mka")

    while read -r F
    do
        [[ -e "$F.oga" ]] || {
            echo "No such file '$F.oga'; maybe rename to lower case?" 1>&2
            continue
        }

           F_ESC=$(echo "$F.oga"  | esc.sh)
        OPUS_ESC=$(echo "$F.opus" | esc.sh)
         OGG_ESC=$(echo "$F.ogg"  | esc.sh)

        if file "$F.oga" | grep -i opus > /dev/null
        then
            echo "'$F_ESC' should be renamed to .opus"
            echo "mv '$F_ESC' '$OPUS_ESC'"
        else
            if file "$F.oga" | grep -i vorbis > /dev/null
            then
                echo "'$F_ESC' should be renamed to .ogg"
                echo "mv '$F_ESC' '$OGG_ESC'"
            else
                echo "Unknown codec in '$F_ESC'"
            fi
        fi
    done < <(withExtIn "oga" "$1")

    while read -r F
    do
        [[ -e "$F.wav" ]] || {
            echo "Couldn't find '$F.wav'; rename to lowercase?" 1>&2
            continue
        }
           F_ESC=$(echo "$F.wav"  | esc.sh)
        OPUS_ESC=$(echo "$F.opus" | esc.sh)

        if file "$F.wav" | grep "WAVE audio" > /dev/null
        then
            echo "'$F_ESC' can be encoded to .opus"
            echo "opusenc --bitrate 128 --comp 10 --max-delay 10 '$F_ESC' '$OPUS_ESC'"
        else
            echo "'$F_ESC' looks like Wave, but 'file' says:"
            file "$F.wav"
            echo
            echo
        fi
    done < <(withExtIn "wav" "$1")

    for EXT in mp4 avi
    do
        while read -r F
        do
            F_ESC=$(echo "$F.$EXT" | esc.sh)
            echo "Found possible video file '$F_ESC'"
        done < <(withExtIn "$EXT" "$1")
    done
}

if [[ "$#" -gt 0 ]]
then
    [[ -d "$1" ]] || {
        echo "'$1' isn't a directory, aborting"
        exit 1
    }
    checkFilesIn "$1"
else
    for I in Music/Commercial/*
    do
        I_ESC=$(echo "$I" | esc.sh)
        [[ -d "$I" ]] || {
            echo "'$I_ESC' isn't a directory"
            continue
        }

        for ARTIST in "$I"/*
        do
            ARTIST_ESC=$(echo "$ARTIST" | esc.sh)
            [[ -d "$ARTIST" ]] || {
                echo "'$ARTIST_ESC' isn't a directory"
                continue
            }

            for ALBUM in "$ARTIST"/*
            do
                ALBUM_ESC=$(echo "$ALBUM" | esc.sh)
                [[ -d "$ALBUM" ]] || {
                    echo "'$ALBUM_ESC' isn't a directory"
                    continue
                }

                for TRACK in "$ALBUM"/*
                do
                    TRACK_ESC=$(echo "$TRACK" | esc.sh)
                    [[ -f "$TRACK" ]] || {
                        echo "'$TRACK_ESC' isn't a file"
                        continue
                    }
                done
            done

            checkFilesIn "$ARTIST"
        done
    done
fi
