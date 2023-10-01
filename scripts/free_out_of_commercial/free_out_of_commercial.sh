#!/usr/bin/env bash

# Look through the Music/Commercial directory for files which we know should be
# in Music/Free (e.g. those from OCRemix, Newgrounds, etc.)

function free_dirs {
    # Directories which should be in Free rather than Commercial
    echo "Checking for specific directories" 1>&2
    for D in "N/Nanowar" "W/Wenlock" "Z/ZX Spectrum" "C/Chiptunes"
    do
        [[ -d "$D" ]] && echo "$D"
    done
    for PAT in 'Final Fantasy VII*' 'Newgrounds Audio Portal*' \
               'Sonic the Hedgehog 2*' '*ocremix.org*'
    do
        echo "Looking for directories matching '$PAT'" 1>&2
        find . -type d -name "$PAT"
    done
}

function free_out_of_commercial {
    # Move directories which should be in Free out of Commercial
    # (Mostly to appease Jo)
    pushd Music/Commercial > /dev/null || return
    mkdir -p ../Free
    while read -r DIR
    do
        PARENT=$(dirname "$DIR")
        mkdir -p ../Free/"$PARENT"
        move_command "$PWD/$DIR" "$PWD/../Free/$DIR"
    done < <(free_dirs)
    popd > /dev/null || return
}

free_out_of_commercial
