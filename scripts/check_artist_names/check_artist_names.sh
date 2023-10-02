#!/usr/bin/env bash
set -e

# For each artist directory in Music/Commercial/*, invoke
# `check_on_metalarchive`. If that fails, invoke `check_on_lastfm`. If both
# fail, report the artist as not being found.

function assertDir {
    [[ -d "$1" ]] || {
        echo "Error: '$1' isn't a directory" 1>&2
        return 1
    }
    return 0
}

function checkArtistDir {
    ARTIST=$(basename "$1")
    if check_on_metalarchive "$ARTIST"
    then
        return 0
    fi
    check_on_lastfm "$ARTIST"
}

for D1 in Music/Commercial/*
do
    assertDir "$D1" || continue
    INIT=$(basename "$D1")
    export INIT

    for D2 in "$D1/"*
    do
        assertDir "$D2" || continue

        checkArtistDir "$D2" || {
            echo "Error: Failed to find artist for '$D2'" 1>&2
        }
    done
done
