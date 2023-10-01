#!/usr/bin/env bash
set -e

[[ "$#" -eq 3 ]] ||
    fail "Need 3 arguments: artist dir, artist name, artist country"

ARTIST_DIR="$1"
NAME="$2"
CNT="$3"

[[ -d "$ARTIST_DIR" ]] ||
    fail "Given '$ARTIST_DIR' isn't an artist directory"

[[ -n "$NAME" ]] ||
  fail "Empty name for dir '$ARTIST_DIR'"

INIT=$(basename "$ARTIST_DIR" | cut -c1)
if echo "$INIT" | grep -v '^[a-zA-Z]' > /dev/null
then
    INIT='Other'
fi
if echo "$INIT" | grep '^[0-9]' > /dev/null
then
    INIT='0-9'
fi

ALBUM_CACHE=".artist_name_cache/$INIT/${NAME}_${CNT}.albums"

if [[ -f "$ALBUM_CACHE" ]]
then
    # Extract all album names
    album_names_from < "$ALBUM_CACHE" | cut -f1
else
    echo "No cached albums at '$ALBUM_CACHE'" 1>&2
fi
exit 0
