#!/usr/bin/env bash
while read -r FILE
do
    NAME=$(basename "$FILE")
    KNOWN=0
    for SUFFIX in aac mp3 ogg oga opus m4a wma
    do
        if echo "$NAME" | grep -i '\.'"$SUFFIX"'$' > /dev/null
        then
            KNOWN=1
        fi
    done

    if [[ "$KNOWN" -eq 0 ]]
    then
        echo "Don't know how to handle: $FILE"
        continue
    fi

    ARTIST=$(basename "$1")

    echo "Setting artist to '$ARTIST' in '$FILE'" 1>&2
    set_tag "artist" "$ARTIST" "$FILE"
done < <(find "$1" -type f)
