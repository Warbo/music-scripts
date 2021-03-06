#!/usr/bin/env bash

# Look for non-music files in the Music directory. For example, image files,
# text files and rubbish left behind by inferior operating systems.

DIR="$1"
[[ -n "$DIR" ]] || DIR="Music"

PREFIXED=0

while read -r P
do
    [[ -n "$P" ]] || continue
    if [[ "$PREFIXED" -eq 0 ]]
    then
        PREFIXED=1
        echo "Found crap you might want to delete" 1>&2
    fi
    echo "$P"
done < <(find "$DIR"  -name '.DS_Store' \
                 -or -iname "*.db"      \
                 -or -iname "*.gif"     \
                 -or -iname "*.htm"     \
                 -or -iname "*.html"    \
                 -or -iname "*.ico"     \
                 -or -iname "*.ini"     \
                 -or -iname "*.jpeg"    \
                 -or -iname "*.jpg"     \
                 -or -iname "*.m3u"     \
                 -or -iname "*.nfo"     \
                 -or -iname "*.onetoc2" \
                 -or -iname "*.png"     \
                 -or -iname "*.sfv"     \
                 -or -iname "*.tif"     \
                 -or -iname "*.txt"     \
                 -or -iname "*.url")
