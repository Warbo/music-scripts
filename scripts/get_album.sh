#!/usr/bin/env bash
set -e

# Given an artist name, an album name and a YouTube playlist URL, creates the
# appropriate directory (if needed) and extracts the audio from the playlist
# tracks using `youtube-dl`. `tag_album_dir` is invoked afterwards.

# Uses TaskSpooler to queue up download and tagging processes, if available.

[[ -d Music/Commercial ]] || {
    echo "Can't find Music/Commercial; check working directory" 1>&2
    exit 1
}

for A in "$1" "$2" "$3"
do
    [[ -n "$A" ]] || {
        echo "Usage: get_album.sh ARTIST ALBUM URL" 1>&2
        exit 1
    }
done

ARTIST="$1"
 ALBUM="$2"
   URL="$3"

echo "Fetching '$ALBUM' by '$ARTIST' from URL '$URL'. Kill me if wrong..." 1>&2

for COUNT in 3 2 1
do
    echo "$COUNT..."
    sleep 5
done

INIT=$(echo "$1" | cut -c 1 | tr '[:lower:]' '[:upper:]')
DIR="Music/Commercial/$INIT/$ARTIST/$ALBUM"

mkdir -p "$DIR"
pushd "$DIR" > /dev/null

# Prefer opus, then vorbis, then whatever youtube-dl thinks is best
FORMATS="251/171/bestaudio/best"
if command -v "ts" > /dev/null 2>/dev/null
then
    ts youtube-dl -i -f "$FORMATS" -x "$URL"
    echo "Download is queued" 1>&2
    ts tag_album_dir "$(readlink -f .)"
else
    echo "ts not found, fetching directly..." 1>&2
    youtube-dl -i -f "$FORMATS" -x "$URL"
    tag_album_dir "$(readlink -f .)"
fi
