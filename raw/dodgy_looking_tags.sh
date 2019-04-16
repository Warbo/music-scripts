#!/usr/bin/env bash

function go {
  find "$1" -type f | while read -r F
  do
    printf '.' 1>&2
    TAGS=$(mutagen-inspect "$F")

    if echo "$TAGS" | grep '\s$' > /dev/null
    then
      echo
      echo "$F has tag ending in whitespace"
      echo
    fi

    if echo "$TAGS" | grep '=\s' > /dev/null
    then
      echo
      echo "$F has tag beginning with whitespace"
      echo
    fi

    for DODGY in "music.download.com"
    do
      if echo "$TAGS" | grep -F "$DODGY"
      then
        echo
        echo "$F has dodgy tags"
        echo
      fi
    done
  done
}

if [[ "$#" -gt 0 ]]
then
  DIR="$1"
  [[ -d "$DIR" ]] || fail "Given directory '$DIR' not found, aborting"
  go "$DIR"
else
  DIR=Music/Commercial
  [[ -d "$DIR" ]] || fail "Couldn't find '$DIR', maybe change working dir?"
  for INIT in "$DIR"/*
  do
    [[ -d "$INIT" ]] || continue
    for ARTIST in "$INIT"/*
    do
      [[ -d "$ARTIST" ]] || continue
      go "$ARTIST"
    done
  done
fi
