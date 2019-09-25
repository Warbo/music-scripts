#!/usr/bin/env bash
set -e

# If we've renamed files using Picard, they'll have names like '01 Title.mp3'
# If there are duplicates, they'll be named '01 Title (1).mp3', etc.
# This script looks for such filenames, as well as filenames which only differ
# in file extension (we prefer opus, then ogg; wma is least preferable)

# NOTE: It is recommended to run, and act on the output of, the
# move_into_album_dirs script before using this one. This is because files from
# different albums, appearing in the same directory, may still conflict with
# each other.

function findNumbered {
    echo "Looking for duplicates, based on numbered filenames"
    find "$1" -type f | grep ' ([0-9][0-9]*)\.[^\.]*' | while read -r F
    do
        # Make sure there's a non-numbered file
        # shellcheck disable=SC2001
        MAIN=$(echo "$F" | sed -e 's/ ([0-9][0-9]*)\././g')
        if [[ -e "$MAIN" ]]
        then
            echo "rm '$(echo "$F" | esc)'"
        else
            echo "File '$F' is named like a dupe, but it isn't one. Try:"
            move_command "$F" "$MAIN"
        fi
    done
    echo "End numbered filename duplicates"
}

function getExt {
    echo "$1" | grep -o '[^\.]*$'
}

function formatPriority {
    E=$(getExt "$1" | tr '[:upper:]' '[:lower:]')
    case "$E" in
        opus)
            echo 60
        ;;

        ogg)
            echo 50
        ;;

        m4a)
            echo 40
        ;;

        aac)
            echo 30
        ;;

        mp3)
            echo 20
        ;;

        wma)
            echo 10
        ;;
    esac
}

function findMultipleFormats {
    echo "Looking for duplicates, based on differing 'file extensions'"
    find "$1" -type f | while read -r F
    do
        # Note that if there is a duplicate, we'll end up looping once for the
        # preferred format and once for each duplicate, in an unknown order.

        # shellcheck disable=SC2001
        REST=$(echo "$F" | sed -e 's/[^\.]*$//g')
         EXT=$(formatPriority "$F")

        # Use shell globbing to loop through filenames which match up to the
        # extension; we do this rather than using 'find', since our stdin is
        # already tied up with the outer 'find' invocation.
        for F2 in "$REST"*
        do
            # If we've found ourselves, skip
            [[ "x$F" = "x$F2" ]] && continue

            # Turn the file extension into a number and compare
            EXT2=$(formatPriority "$F2")
            if [[ "$EXT2" -lt "$EXT" ]]
            then
                echo "File $F2 is worse format than $F:"
                echo "rm '$(echo "$F2" | esc)'"
            fi
        done
    done
    echo "End of 'file extension' duplicates"
}

if [[ "$#" -gt 0 ]]
then
    for D in "$@"
    do
        findNumbered "$D"
        findMultipleFormats "$D"
    done
else
    for D in Music/Commercial/*/*
    do
        [[ -d "$D" ]] || continue
        findNumbered "$D"
        findMultipleFormats "$D"
    done
fi
