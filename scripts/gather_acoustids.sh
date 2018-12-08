#!/usr/bin/env bash
set -euo pipefail

## Don't run directly, use gather_acoustids.nix to bake-in dependencies

function getField() {
    grep "^$1=" | sed -e "s/$1=//g"
}

function getAcoustID() {
    echo "Fingerprinting $1" 1>&2
    RESULT=$(fpcalc -raw "$1" | grep -v "^FILE=")

       DURATION=$(echo "$RESULT" | getField 'DURATION')
    FINGERPRINT=$(echo "$RESULT" | getField 'FINGERPRINT')

    echo -e "$1\\t$DURATION\\t$FINGERPRINT" >> .acoustids
}

function alreadyKnown() {
    [[ -e .acoustids ]] || return 1
    cut -f1 < .acoustids | grep -Fx "$1" > /dev/null
}

while read -r F
do
    alreadyKnown "$F" && continue
    getAcoustID "$F"
done
