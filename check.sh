#!/usr/bin/env bash
set -e

# Simple, quick sanity check. Useful as a git pre-commit hook.
find . -name "*.nix" | while read -r F
do
    echo "Checking '$F'" 1>&2
    nix-instantiate --parse "$F" > /dev/null
done

# Allow failure to get HEAD (e.g. in case we're offline)
REPO="warbo-utilities"
F="scripts/$REPO.nix"

echo "Checking $REPO version in $F" 1>&2
if REV=$(git ls-remote "http://chriswarbo.net/git/$REPO.git" |
         grep HEAD | cut -d ' ' -f1 | cut -c1-7)
then
    grep "$REV" < "$F" || {
        echo "Didn't find $REPO rev '$REV' in $F" 1>&2
        exit 1
    }
fi

exit 0
