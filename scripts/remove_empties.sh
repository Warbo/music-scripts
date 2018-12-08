#!/usr/bin/env bash
echo "Looking for empty directories in Music/"
find "Music" -type d -empty | while read -r D
do
    TICK="'"
    # shellcheck disable=SC2001
    ESCAPED=$(echo "$D" | sed -e "s@$TICK@$TICK\\$TICK$TICK@g")
    echo "rmdir '$ESCAPED'"
done

echo "Looking for empty files in Music/"
find "Music" -type f -empty
