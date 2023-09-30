#!/usr/bin/env bash

# Look for dodgy whitespace in filenames, which is either ugly or may lead
# to dupes. Includes 'double  spaces', ' initial spaces' and
# 'spaces before .extensions'

if [[ "$#" -eq 0 ]]
then
    DIR="Music"
else
    DIR="$1"
fi

while read -r NAME
do
    DIR=$(dirname "$NAME")
    FILE=$(basename "$NAME")

    # shellcheck disable=SC2001
    NORMAL=$(echo "$FILE" | sed -e 's/   */ /g')

    SRC="$DIR/$FILE"
    DST="$DIR/$NORMAL"
    if [[ -e "$DST" ]]
    then
        echo "'$SRC' has dodgy whitespace, but '$DST' exists"
    else
        move_command "$SRC" "$DST"
    fi
done < <(find "$DIR" -name '*  *')
while read -r NAME
do
    DIR=$(dirname "$NAME")
    FILE=$(basename "$NAME")

    # shellcheck disable=SC2001
    NORMAL=$(echo "$FILE" | sed -e 's/^  *//g')

    SRC="$DIR/$FILE"
    DST="$DIR/$NORMAL"
    if [[ -e "$DIR/$NORMAL" ]]
    then
        echo "'$SRC' has dodgy whitespace, but '$DST' exists"
    else
        move_command "$SRC" "$DST"
    fi
done < <(find "$DIR" -name ' *')
while read -r NAME
do
    DIR=$(dirname "$NAME")
    FILE=$(basename "$NAME")

    # shellcheck disable=SC2001
    NORMAL=$(echo "$FILE" | sed -e 's/  *\.\([^\.]*\)$/\.\1/g')

    SRC="$DIR/$FILE"
    DST="$DIR/$NORMAL"
    [[ "$FILE" = "$NORMAL" ]] && continue
    if [[ -e "$DST" ]]
    then
        echo "'$SRC' has dodgy whitespace, but '$DST' exists"
    else
        move_command "$SRC" "$DST"
    fi
done < <(find "$DIR" -name '* .*')
