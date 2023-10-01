#!/usr/bin/env bash
set -e

# Run the "fdupes" command to find duplicate files, once per artist directory.

for LETTER in Music/*
do
    [[ -d "$LETTER" ]] || continue
    for ARTIST in "$LETTER"/*
    do
        [[ -d "$ARTIST" ]] || continue
        fdupes -d -r "$ARTIST"
    done
done
