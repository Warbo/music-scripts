#!/usr/bin/env bash
set -e

# Copy music from ~/Downloads/Music into ~/Public/Music then move to ~/Music.
# Useful if we've downloaded things locally using get_album, tagged using Picard
# and now need to push to the raspberry pi.

D="/home/chris/Downloads/Music"
[[ "$PWD" = "$D" ]] ||
    fail "Wrong dir; you should cd $D"

cd "Music/Commercial"
find . -type f | while read -r F
do
    while ! [[ -d ~/Public/Music/Commercial ]]
    do
        echo "Looks like ~/Public is unmounted; waiting..." 1>&2
    done

    D=$(dirname "$F")
    mkdir -p ~/Public/Music/Commercial/"$D"
    keep_trying copy "$F" ~/Public/Music/Commercial/"$D"/

    mkdir -p ~/Music/Commercial/"$D"
    mv -v "$F" ~/Music/Commercial/"$D"/
done

find . -type d -empty | while read -r D
do
    rmdir "$D"
done
