#!/usr/bin/env bash
set -euo pipefail

## Don't run directly, use gather_acoustids.nix to bake-in dependencies

function getField() {
    grep "^$1=" | sed -e "s/$1=//g"
}

function getAcoustID() {
    # Takes file path as first arg (e.g. 'Music/Commercial/A/Artist/track.mp3')
    # and cache path as second arg (e.g. '.acoustid_cache/A/Artist'). Calculates
    # AcoustID of the music file and appends it to the cache file.
    echo "Fingerprinting $1" 1>&2
    if RESULT=$(fpcalc -raw "$1")
    then
           DURATION=$(echo "$RESULT" | getField 'DURATION')
        FINGERPRINT=$(echo "$RESULT" | getField 'FINGERPRINT')

        echo -e "$1\\t$DURATION\\t$FINGERPRINT" >> "$2"
    fi
}

function alreadyKnown() {
    # Takes file path as first arg (e.g. 'Music/Commercial/A/Artist/track.mp3')
    # and cache path as second arg (e.g. '.acoustid_cache/A/Artist'). Returns
    # whether or not the cache contains an entry for that file (if the cache
    # file doesn't exist, that counts as not having an entry)
    [[ -e "$2" ]] || return 1
    cut -f1 < "$2" | grep -Fx "$1" > /dev/null
}

function cacheFromPath() {
    # Takes a file path as arg (e.g. 'Music/Commercial/A/Artist/track.mp3') and
    # echoes the relevant cache file name (e.g. '.acoustid_cache/A/Artist')
    I=$(echo "$1" | cut -d '/' -f 3)
    A=$(echo "$1" | cut -d '/' -f 4)
    echo ".acoustid_cache/$I/$A"
}

function processInitial() {
    # Takes a path to an initial directory (e.g. 'Music/Commercial/A') and
    # processes all artists in that directory.
    for ARTIST in "$1"/*
    do
        if [[ -d "$ARTIST" ]]
        then
            processArtist "$ARTIST"
        fi
    done
}

function processArtist() {
    # Takes a path to an artist (e.g. 'Music/Commercial/A/Artist') and processes
    # all files in that directory.

    # Find (or create) the cache and read all of the filenames it contains
    CACHE=$(cacheFromPath "$1")
    PARENT=$(dirname "$CACHE")
    mkdir -p "$PARENT"
    unset PARENT
    touch "$CACHE"
    KNOWN=$(cut -f1 < "$CACHE")

    # Loop through every file in this artist directory
    while read -r F
    do
        # Grep for this file in the cached paths, skip it if found
        if echo "$KNOWN" | grep -Fx "$F" > /dev/null
        then
            printf '.' 1>&2
            continue
        fi

        # If not found, calculate the the AcoustID and append it to the cache
        getAcoustID  "$F" "$CACHE"
    done < <(find "$1" -type f)
}

# If we've been called with an argument, use that as the path for finding files.
# Otherwise default to 'Music/Commercial'.
DIR="${1:-Music/Commercial}"

echo "$DIR" | grep '^Music/Commercial' > /dev/null || {
    echo "Error: Argument '$DIR' doesn't begin with 'Music/Commercial'" 1>&2
    echo "Aborting, since this will not match any cached values."       1>&2
    exit 1
}

# We process one artist at a time, so that we only need to read each cache once.
# See if we've been given exactly one artist to process.
ARTIST=$(echo "$DIR" | cut -d '/' -f 4)
if [[ -n "$ARTIST" ]]
then
    processArtist "$DIR"
else
    # We've not got one artist, but maybe we have one initial
    INIT=$(echo "$DIR" | cut -d '/' -f 3)
    if [[ -n "$INIT" ]]
    then
        processInitial "$DIR"
    else
        # If we're here then we're processing everything in 'Music/Commercial'
        for INIT in "$DIR"/*
        do
            processInitial "$INIT"
        done
    fi
fi
