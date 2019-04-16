#!/usr/bin/env bash
set -e

function haveLastFm {
    CACHED="$CACHE_DIR/$INIT/$1_$2"
    if [[ -f "$CACHED" ]]
    then
        true
    else
        echo "Looking up '$1' ('$2') on last.fm" 1>&2
        sleep 1
        ENCODED=$(echo "$1" | tr ' ' '+')
        curl -L --get "http://www.last.fm/music/$ENCODED" > "$CACHED"
    fi
    if grep "404 - Page Not Found" < "$CACHED" > /dev/null
    then
        echo "Couldn't find '$1' on last.fm" 1>&2
        return 1
    fi
    return 0
}

if [[ -z "$INIT" ]]
then
    if [[ -n "$2" ]]
    then
        INIT="$2"
    fi
fi
[[ -n "$INIT" ]] ||
    fail "No INIT set, aborting"

CACHE_DIR="$PWD/.lastfm_artist_cache"
mkdir -p "$CACHE_DIR/$INIT"

    NAME=$(basename "$1")
NAME_CNT=$(dir_to_artist_country.sh "$NAME")
BANDNAME=$(echo "$NAME_CNT" | cut -f1)
     CNT=$(echo "$NAME_CNT" | cut -f2)

haveLastFm "$BANDNAME" "$CNT"
