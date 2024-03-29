#!/usr/bin/env bash
set -e

# Given a directory path ending in "FOO/BAR", will use `fmmpeg` to set all of
# the "Artist" tags of the contents to "FOO" and all of the "Album" tags to
# "BAR".

# Uses ffmpeg to ensure the audio data isn't changed, by comparing the CRC
# before and after.

[[ -n "$1" ]] ||  {
    echo "Usage: tag_album_dir path/to/ARTIST/ALBUM" 1>&2
    exit 1
}

[[ -d "$1" ]] || {
    echo "No such directory '$1'" 1>&2
    exit 1
}

ALBUM=$(basename "$1")
ARTIST=$(basename "$(dirname "$1")")

echo "Tagging everything in '$1' as '$ALBUM' by '$ARTIST'" 1>&2
for COUNT in 3 2 1
do
    echo "$COUNT..." 1>&2
done

find "$1" -type f | while read -r SRC
do
    set_tag artist "$ARTIST" "$SRC"
    set_tag album  "$ALBUM"  "$SRC"
done
