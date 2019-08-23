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
            TITLE=$(get_tag title "$FILE") || continue
            [[ -n "$TITLE" ]] && continue
            printf 'Untagged\t'\''%s'\''\n' "$(echo "$FILE" | esc)"
            tags_of "$F" 1>&2
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
