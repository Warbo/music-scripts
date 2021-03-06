#!/usr/bin/env bash
shopt -s nullglob

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
        F_ESC=$(echo "$F" | esc)
        convmv -f utf8 -t utf8 "$F" 1> /dev/null 2> /dev/null ||
            echo "Dodgy characters in $F_ESC Rename it to avoid problems" 1>&2
    done < <(find "$1")

    for DODGE in blogspot magnatune download.com jamendo
    do
        while read -r F
        do
            echo "Path '$F' looks dodgy"
        done < <(find "$1" -iname "*$DODGE*")
    done

    while read -r F
    do
        echo "Found hidden file '$F'"
    done < <(find "$1" -name '.*')

    while read -r F
    do
        echo "Found colon in path '$F'; this will cause problems on FAT drives"

        # shellcheck disable=SC2001
        END=$(basename "$F" | sed -e 's/:/ - /g' -e 's/  */ /g')
        NEW=$(dirname "$F")/"$END"

        if [[ -e "$NEW" ]]
        then
            echo "Suggested alternative '$NEW' already exists: merge or dedupe!"
        else
            echo "Replace the colon with the following command:"
            move_command "$F" "$NEW"
        fi
    done < <(find "$1" -name '*:*')

    # Look for spaces at the start and end of filenames, and around extensions
    while read -r F
    do
        # Allow spaces if there's a "..." somewhere
        echo "$F" | grep '\.\.\.' > /dev/null && continue

        F_ESC=$(echo "$F" | esc)
        echo "Found dodgy whitespace in filename '$F_ESC'"
    done < <(find "$1" -iname ' *';
             find "$1" -iname '* ';
             find "$1" -iname '* .*')

    while read -r F
    do
        F_ESC=$(echo "$F" | esc)
        echo "'$F_ESC' should probably be (losslessly) converted to ogg"
    done < <(find "$1" -iname "*.mka")

    while read -r F
    do
        [[ -e "$F.oga" ]] || {
            echo "No such file '$F.oga'; maybe rename to lower case?" 1>&2
            continue
        }

        if file "$F.oga" | grep -i opus > /dev/null
        then
            echo "'$F' should be renamed to .opus"
            move_command "$F.oga" "$F.opus"
        else
            if file "$F.oga" | grep -i vorbis > /dev/null
            then
                echo "'$F' should be renamed to .ogg"
                move_command "$F.oga" "$F.ogg"
            else
                echo "Unknown codec in '$F'"
            fi
        fi
    done < <(withExtIn "oga" "$1")

    while read -r F
    do
        [[ -e "$F.wav" ]] || {
            echo "Couldn't find '$F.wav'; rename to lowercase?" 1>&2
            continue
        }
           F_ESC=$(echo "$F.wav"  | esc)
        OPUS_ESC=$(echo "$F.opus" | esc)

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

    while read -r F
    do
        [[ -e "$F.flac" ]] || {
            echo "Couldn't find '$F.flac'; rename to lowercase?" 1>&2
            continue
        }
           F_ESC=$(echo "$F.flac" | esc)
        OPUS_ESC=$(echo "$F.opus" | esc)

        echo "'$F_ESC' can be encoded to .opus"
        echo "opusenc --bitrate 128 --comp 10 --max-delay 10 '$F_ESC' '$OPUS_ESC'"
    done < <(withExtIn "flac" "$1")

    for EXT in mp4 avi webm
    do
        while read -r F
        do
            F_ESC=$(echo "$F.$EXT" | esc)
            echo "Found possible video file '$F_ESC'"
        done < <(withExtIn "$EXT" "$1")
    done

    # Look for entries which differ only in case
    PAIRED=$(find "$1" | while read -r P;
    do
        LOWER=$(echo "$P" | tr '[:upper:]' '[:lower:]')
        printf '%s\t%s\n' "$LOWER" "$P"
    done)

    # Loop through duplicates, one entry per group
    echo "$PAIRED" | cut -f1 | sort | uniq -d | while read -r LOWER
    do
        UPPERS=$(echo "$PAIRED" | grep -F "$LOWER	" | while read -r PAIR
                 do
                     # Check the entire first field matches; not just at the end
                     if echo "$PAIR" | cut -f1 | grep -Fx "$LOWER" > /dev/null
                     then
                         echo "$PAIR" | cut -f2
                     fi
                 done)
        [[ -z "$UPPERS" ]] && continue
        echo "# The following paths differ only in case:"
        echo "$UPPERS"
        echo "# End case-insensitive matching"
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
        I_ESC=$(echo "$I" | esc)
        [[ -d "$I" ]] || {
            echo "'$I_ESC' isn't a directory"
            continue
        }

        for ARTIST in "$I"/*
        do
            ARTIST_ESC=$(echo "$ARTIST" | esc)
            [[ -d "$ARTIST" ]] || {
                echo "'$ARTIST_ESC' isn't a directory"
                continue
            }

            for ALBUM in "$ARTIST"/*
            do
                ALBUM_ESC=$(echo "$ALBUM" | esc)
                [[ -d "$ALBUM" ]] || {
                    echo "'$ALBUM_ESC' isn't a directory"
                    continue
                }

                for TRACK in "$ALBUM"/*
                do
                    TRACK_ESC=$(echo "$TRACK" | esc)
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
