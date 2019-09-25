#!/usr/bin/env bash

# Uses `strip_name` to compare each line of stdin with those which came before,
# looking for possible duplicate filenames.

# \n-separated list of names and their simplified alternatives
NAMES=""
while read -r INCOMING
do
    NAME=$(basename "$INCOMING")

    # Upper -> lower, remove non-alphabetic
    ALT=$(strip_name "$NAME")

    if DUPE=$(echo "$NAMES" | grep -- "$ALT")
    then
        echo "$INCOMING looks like:"
        echo "$DUPE" | grep -o "DIR:.*     " |
                       grep -o ": .*" |
                       grep -o " .*"  |
                       grep -o "[^ ].*"
        echo "END"
    fi

    NAMES="$NAMES
DIR: $INCOMING     ALT: $ALT"
done
