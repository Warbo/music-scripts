#!/usr/bin/env bash

# Look for dodgy whitespace in filenames, which is either ugly or may lead
# to dupes. Includes 'double  spaces', ' initial spaces' and
# 'spaces before .extensions'

function esc {
    sed -e "s@'@'\\\\''@g"
}

while read -r NAME
do
    DIR=$(dirname "$NAME")
    FILE=$(basename "$NAME")
    NORMAL=$(echo "$FILE" | sed -e 's/   */ /g')
    SRC=$(echo "$DIR/$FILE"   | esc)
    DST=$(echo "$DIR/$NORMAL" | esc)
    if [[ -e "$DIR/$NORMAL" ]]
    then
        echo "'$SRC' has dodgy whitespace, but '$DST' exists"
    else
        echo "mv -v '$SRC' '$DST'"
    fi
done < <(find Music -name '*  *')
while read -r NAME
do
    DIR=$(dirname "$NAME")
    FILE=$(basename "$NAME")
    NORMAL=$(echo "$FILE" | sed -e 's/^  *//g')
    SRC=$(echo "$DIR/$FILE"   | esc)
    DST=$(echo "$DIR/$NORMAL" | esc)
    if [[ -e "$DIR/$NORMAL" ]]
    then
        echo "'$SRC' has dodgy whitespace, but '$DST' exists"
    else
        echo "mv -v '$SRC' '$DST'"
    fi
done < <(find Music -name ' *')
while read -r NAME
do
    DIR=$(dirname "$NAME")
    FILE=$(basename "$NAME")
    NORMAL=$(echo "$FILE" | sed -e 's/  *\.\([^\.]*\)$/\.\1/g')
    SRC=$(echo "$DIR/$FILE"   | esc)
    DST=$(echo "$DIR/$NORMAL" | esc)
    [[ "x$FILE" = "x$NORMAL" ]] && continue
    if [[ -e "$DST" ]]
    then
        echo "'$SRC' has dodgy whitespace, but '$DST' exists"
    else
        echo "mv -v '$SRC' '$DST'"
    fi
done < <(find Music -name '* .*')
