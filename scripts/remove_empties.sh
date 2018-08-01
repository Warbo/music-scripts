#!/usr/bin/env bash
echo "Looking for empty directories in Music/"
find "Music" -type d -empty | while read -r D
do
    # shellcheck disable=SC2001
    ESCAPED=$(echo "$D" | sed -e "s@'@'\\\''@g")
    echo "rmdir '$ESCAPED'"
done

echo "Looking for empty files in Music/"
find "Music" -type f -empty
