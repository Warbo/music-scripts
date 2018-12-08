#!/usr/bin/env bash

echo "Looking for crap you might want to delete" 1>&2

DIR="$1"
[[ -n "$DIR" ]] || DIR="Music"

find "$DIR" -iname "*.db"      \
        -or -iname "*.jpg"     \
        -or -iname "*.jpeg"    \
        -or -iname "*.png"     \
        -or -iname "*.url"     \
        -or -iname "*.txt"     \
        -or -iname "*.ini"     \
        -or -iname "*.onetoc2" \
        -or -iname "*.htm"     \
        -or -iname "*.html"
