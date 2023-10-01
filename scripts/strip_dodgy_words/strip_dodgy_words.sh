#!/usr/bin/env bash
set -euo pipefail

function check() {
    # Loop through a load of words which probably don't belong in a filename
    # (e.g. they might come from youtube video titles)
    for WORD in 'official lyric video'       \
                'lyric video'                \
                'with lyrics'                \
                'lyrics'                     \
                'official music video'       \
                'official playthrough video' \
                'music video'                \
                'official video'             \
                'official audio'             \
                'official track stream'      \
                'official track'             \
                'official single'            \
                'video'                      \
                'official'                   \
                'unofficial'                 \
                'high quality'               \
                'album track'                \
                'audio hq'                   \
                'HQ'                         \
                '(cc)'                       \
                'Hi Def'
    do
        # Look for a few variations of these words
        for PATTERN in "($WORD)" '['"$WORD"']' '{'"$WORD"'}' \
                                 "［$WORD］" "$WORD"
        do
            # If found, report it and return success. Note that it's better to
            # let grep spit out the match, rather than echoing $PATTERN, since
            # the former is in the correct case, making replacement easy.
            if echo "$1" | grep -ioF "$PATTERN"
            then
                return 0
            fi
        done
    done

    # Return failure if none of the dodgy words were found
    return 1
}

# Take a directory (e.g. an artist) as argument; default to Music/Commercial
START="${1:-Music/Commercial}"

# Look through all files
while read -r LINE
do
    # See if this file's name is dodgy
    NAME=$(basename "$LINE")
    if DODGY=$(check "$NAME")
    then
        # Generate a 'mv' command to rename it (escaping as needed)
        DIR=$(dirname "$LINE")

        # shellcheck disable=SC2001
        REP=$(echo "$NAME"     | replace "$DODGY" "" |
                                 sed -e 's/  */ /g' \
                                     -e 's/ \(\.[^.]*\)$/\1/g')
        move_command "$LINE" "$DIR/$REP"
    fi
done < <(find "$START" -type f)
