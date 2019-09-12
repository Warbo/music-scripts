#!/usr/bin/env bash
if [[ "$#" -eq 0 ]]
then
    DIR="Music"
else
    DIR="$1"
fi

echo "Looking for empty directories in '$DIR'"
find "$DIR" -type d -empty | while read -r D
do
    ESCAPED=$(echo "$D" | esc)
    echo "Empty directory found: $ESCAPED"
    echo "rmdir '$ESCAPED'"
done

echo "Looking for empty files in '$DIR'"
find "$DIR" -type f -empty
