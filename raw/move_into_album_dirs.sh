#!/usr/bin/env bash
set -e

function same {
    X=$(echo "$1" | tr -dc '[:alnum:]' | tr '[:upper:]' '[:lower:]')
    Y=$(echo "$2" | tr -dc '[:alnum:]' | tr '[:upper:]' '[:lower:]')
    if [[ "x$X" = "x$Y" ]]
    then
        return 0
    fi
    return 1
}

function skipTop {
    if [[ "$SKIP_TOP" -eq 1 ]]
    then
        return 0
    else
        return 1
    fi
}

skipTop || {
  TOP='Music/Commercial'
  [[ -d "$TOP" ]] || fail "Didn't find '$TOP' (change dir, or set SKIP_TOP=1)"
  TOP=$(readlink -f "$TOP")
}

function processDir {
    DIR=$(readlink -f "$1")
    if skipTop
    then
        # We're skipping the usual hierarchy, e.g. to clean up some external
        # files like new downloads before they're merged in.
        # We'll assume that the given dir is ARTIST and we'll ignore INIT.
        true
    else
        # If we're sticking to the usual hierarchy, we can look for the exact
        # INIT/ARTIST/ALBUM path that we want
        echo "$DIR" | grep "^$TOP/" > /dev/null ||
        fail "Given dir '$DIR' doesn't begin with '$TOP'"

          BITS=$(echo "$DIR"  | sed  -e "s@^$TOP/@@g" | tr '/' '\n')
        ARTIST=$(echo "$BITS" | head -n2 | tail -n1)

        [[ -n "$INIT"              ]] || INIT=$(echo "$ARTIST" | cut -c1)
        [[ -d "$TOP/$INIT"         ]] || fail "No dir '$TOP/$INIT'"
        [[ -d "$TOP/$INIT/$ARTIST" ]] || fail "No dir '$TOP/$INIT/$ARTIST'"
    fi

    while read -r F
    do
        ALBUM=$(get_tag album "$F") || continue
        [[ -n "$ALBUM" ]]           || continue

        # Remove any leading dots, since that would hide the directory
        # Replace any colons with ' -' to work on FAT/NTFS filesystems
        # Replace any / with _ to prevent subdirectories
        ALBUM=$(echo "$ALBUM" | sed -e 's/^\.*//g' \
                                    -e 's/:/ -/g'  \
                                    -e 's@/@_@g')

        if skipTop
        then
            P="$DIR/$ALBUM"
        else
            P="$TOP/$INIT/$ARTIST/$ALBUM"
        fi

        D=$(dirname "$(readlink -f "$F")")
        same "$D" "$P" || {
            EP=$(echo "$P" | esc)

            echo "# File '$F' has album '$ALBUM'; move with command:"
            echo "mkdir -p '$EP'"
            move_command "$F" "$P/"
        }
    done < <(find "$DIR" -type f)
}

if [[ -n "$1" ]]
then
    processDir "$1"
else
    skipTop && fail "Need an artist dir when SKIP_TOP is set"
    for I in Music/Commercial/*
    do
        [[ -d "$I" ]] || continue
        INIT=$(basename "$I")
        for A in "$I"/*
        do
            [[ -d "$A" ]] || continue
            processDir "$A"
        done
    done
fi
