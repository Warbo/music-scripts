#!/usr/bin/env bash

function hasSuffix() {
    if echo "$2" | grep -i "\\.$1"'$' > /dev/null
    then
        return 0
    else
        return 1
    fi
}

function go {
    while read -r FILE
    do
        if hasSuffix "mp3"  "$FILE" ||
           hasSuffix "ogg"  "$FILE" ||
           hasSuffix "oga"  "$FILE" ||
           hasSuffix "opus" "$FILE" ||
           hasSuffix "wma"  "$FILE" ||
           hasSuffix "m4a"  "$FILE"
        then
            TAGS=$(tags_of "$FILE")
            if echo "$TAGS" | grep -i 'title' > /dev/null
            then
                continue
            fi
            echo "$TAGS" 1>&2
            printf 'Untagged\t'\''%s'\''\n' "$(echo "$FILE" | esc)"
        else
            echo "Don't know format of '$FILE'" 1>&2
        fi
    done < <(find "$1" -type f)
}

if [[ "$#" -eq 0 ]]
then
    go "Music/Commercial"
else
    for DIR in "$@"
    do
        go "$DIR"
    done
fi
