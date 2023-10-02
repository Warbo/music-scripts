#!/usr/bin/env bash

## Always call via available_albums.nix to ensure we have dependencies

# For each artist directory in Music/Commercial/*, see if we have a cached
# albums file. If so, loop through the cached albums and see if anything inside
# the artist directory matches (using `strip_name`). If not, report the album as
# missing.

function process_artist() {
    ARTIST_DIR="$1"

    DIR_NAME=$(basename "$ARTIST_DIR")
    NAME_COUNTRY=$(dir_to_artist_country "$DIR_NAME")
    unset DIR_NAME

    NAME=$(echo "$NAME_COUNTRY" | cut -f1)
     CNT=$(echo "$NAME_COUNTRY" | cut -f2)

    ALBUMS=$(albums_of "$ARTIST_DIR" "$NAME" "$CNT")

    # We want to be as fuzzy as possible in our matching, but we need to
    # keep track of what's already been used. If we have an exact match
    # for the album "Foo", we don't want to suggest that directory as a
    # match for "Foo Part II: The Second Chapter".

    # Build a list of directories which aren't exact matches, and albums
    # which haven't been found
    DIRS=""
    UNSEEN="$ALBUMS"
    for D in "$ARTIST_DIR"/*
    do
        # Skip exact matches, and remove them from UNSEEN
        D_BASE=$(basename "$D")
        if echo "$ALBUMS" | grep -Fx -- "$D_BASE" > /dev/null
        then
            UNSEEN=$(echo "$UNSEEN" | grep -vFx -- "$D_BASE")

            # Report if the match isn't a directory
            [[ -d "$D" ]] ||
                echo "ERROR: '$D' is a file, not a directory!" 1>&2

            continue
        fi

        # Skip non-directories
        [[ -d "$D" ]] || continue

        # Otherwise, D seems worth fuzzy-matching
        DIRS=$(echo -e "$DIRS\\n$D" | grep '^.')
    done

    # For each unseen album, look for fuzzy matches
    while read -r ALBUM
    do
        [[ -n "$ALBUM" ]] || continue

        ALBUM_STRIP=$(strip_name "$ALBUM")

        CHARS=$(echo -n "$ALBUM_STRIP" | wc -c)
        if [[ "$CHARS" -lt 4 ]]
        then
            echo "No exact match for '$ALBUM' in '$ARTIST_DIR', and unsuitable for fuzzy matching" 1>&2
            continue
        fi

        ALBUM_NAME_ESC=$(echo "$ALBUM" | esc)
        ALBUM_NOSLASH=$(echo "${ALBUM//\//_}" |
                        sed -e 's/:/ -/g' -e 's/^\.*//g')
        ALBUM_DIR="$ARTIST_DIR/$ALBUM_NOSLASH"

        FOUND=0
        while read -r D
        do
            [[ -n "$D" ]] || continue

            D_BASE=$(basename "$D")
            D_STRIP=$(strip_name "$D_BASE")

            CHARS=$(echo -n "$D_STRIP" | wc -c)

            if [[ "$CHARS" -lt 4 ]]
            then
                echo "Skipping directory '$D' as it's unsuitable for fuzzy matching" 1>&2
                continue
            fi

            D_NOSLASH=$(echo "$D_BASE" | sed -e 's/:/ -/g' -e 's/^\.*//g')

            if [[ "$ALBUM_NOSLASH" = "$D_NOSLASH" ]]
            then
                # Ignore filesystem-significant punctuation differences, i.e.
                # we can't use '/' (subdirectory), ':' (FAT compatibility) or
                # leading '.' (hidden directory)
                FOUND=1
                break
            fi

            if echo "$ALBUM_STRIP" | grep -F -- "$D_STRIP" > /dev/null
            then
                FOUND=1
                echo "Directory '$D' looks like album '$ALBUM'. To rename, do:"
                move_command "$D" "$ALBUM_DIR"
                break
            fi

            if echo "$D_STRIP" | grep -F -- "$ALBUM_STRIP" > /dev/null
            then
                FOUND=1
                echo "Directory '$D' looks like album '$ALBUM'. To rename, do:"
                move_command "$D" "$ALBUM_DIR"
                break
            fi
        done < <(echo "$DIRS")

        if [[ "$FOUND" -eq 0 ]]
        then
            if [[ -n "$CNT" ]]
            then
                echo "Couldn't find album '$ALBUM_NAME_ESC' by $NAME ($CNT)"
            else
                echo "Couldn't find album '$ALBUM_NAME_ESC' by $NAME"
            fi
        fi
    done < <(echo "$UNSEEN")
}

if [[ -n "$1" ]]
then
    process_artist "$1"
    exit
fi

for INIT_DIR in Music/Commercial/*
do
    [[ -d "$INIT_DIR" ]] || continue

    for ARTIST_DIR in "$INIT_DIR"/*
    do
        [[ -d "$ARTIST_DIR" ]] || continue
        process_artist "$ARTIST_DIR"
    done
done
