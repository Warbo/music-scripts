#!/usr/bin/env bash
set -e

# Print a 'mv' command, with appropriate escaping, etc.

SRC="$1"
DST="$2"

[[ -n "$SRC" ]] || fail "No args given (or first arg empty)"
[[ -n "$DST" ]] || fail "Need 2 non-empty args (source and destination)"
[[ -e "$SRC" ]] || fail "File '$SRC' doesn't exist"

# Note that DST might not exist when we print out this 'mv' command, e.g. we may
# also have printed out a 'mkdir' command to create it

SRC_ESC=$(echo "$SRC" | esc)
DST_ESC=$(echo "$DST" | esc)

# Print across two lines, with alignment, to make changes easier to read
# We allow extra unescaped, unquoted text via $3 and $4, e.g. for '/*'
printf 'mv -v '\''%s'\''%s \\\n      '\''%s'\''%s\n' \
       "$SRC_ESC" "$3" "$DST_ESC" "$4"
