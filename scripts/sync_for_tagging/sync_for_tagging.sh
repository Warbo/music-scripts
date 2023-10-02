#!/usr/bin/env bash
set -e

function usage {
    echo "Tagging files over SSHFS is very slow. To avoid this we can copy" 1>&2
    echo "files over, then tag them, then copy them back. This script will" 1>&2
    echo "generate appropriate commands to do this copying."                1>&2
    echo                                                                    1>&2
    echo "Usage:"                                                           1>&2
    echo "  sync_for_tagging ~/Public/Music/Commercial/A/Artist"            1>&2
    echo                                                                    1>&2
    for MSG in "$@"
    do
        echo "$MSG" 1>&2
    done
    fail
}

# Converts a ~/Public/Music path to ~/Music
function home_of {
    # shellcheck disable=SC2001
    echo "$1" | sed -e 's@/home/chris/Public/@/home/chris/@g'
}

# Converts a ~/Music path to ~/Public/
function pub_of {
    # shellcheck disable=SC2001
    echo "$1" | sed -e 's@/home/chris/Music/@/home/chris/Public/Music/@g'
}

 PUB_DIR=$(readlink -f "$1")
HOME_DIR=$(home_of "$PUB_DIR")

echo "$PUB_DIR" | grep '^/home/chris/Public/Music/Commercial/' > /dev/null ||
    usage "Should have ~/Public/Music/Commercial/..., got $PUB_DIR"

[[ -d "$PUB_DIR"  ]] || usage "Couldn't find '$PUB_DIR'"
[[ -d "$HOME_DIR" ]] || mkdir -p "$HOME_DIR"

#echo "Looking for redundant files in '$HOME_DIR'" 1>&2
#find "$HOME_DIR" -type f | while read -r HOME_FILE
#do
#    PUB_FILE=$(pub_of "$HOME_FILE")
#    [[ -e "$PUB_FILE" ]] || {
#        ESC=$(echo "$HOME_FILE" | esc)
#        echo "WILL DELETE $ESC"
#    }
#done

# shellcheck disable=SC2001
 PUB_ESC=$(echo "$PUB_DIR" |
               sed -e 's#/home/chris/Public#pi@dietpi.local:/opt/shared#g' |
               esc)
HOME_ESC=$(echo "$HOME_DIR" | esc)

# A note on rsync options:
# - The "-s" option (AKA --protect-args) means we don't have to escape twice for
#   ssh paths
# - The "-c" option uses a rolling-checksum algorithm to find changes. This will
#   find changes INSIDE files, whereas --append-verify only seems to look at the
#   end of each file (which is useful for resuming, but not for changing tags)
# - The --delete option will delete entries in the destination which don't exist
#   in the source. THIS IS DANGEROUS! Hence why we echo the commands rather than
#   running them automatically, and why we use --dry-run, and why we look for
#   such files above. The most dangerous aspect of this option is if we get the
#   source/destination wrong, e.g. trying to copy A/Artist into A/ we might end
#   up syncing them instead, which will delete all of the artists in A/!
# - We put / at the end of each directory, since this seems to be required to
#   avoid putting one directory inside another (e.g. A/Artist/Artist)
echo "The following command will sync (copy files, delete obsolete) FROM"   1>&2
echo "the RaspberryPi TO our laptop. That ensures we tag the latest files." 1>&2
echo "ALWAYS use the given --dry-run option first, THEN run again without"  1>&2
echo "rsync --dry-run -s -c --delete --progress -r --inplace $PUB_ESC/ $HOME_ESC/"
echo
echo
echo "Once the artist has been synced, it can be tagged (e.g. with Picard)" 1>&2
echo
echo
echo "The following will copy BACK (once we've tagged them)"                1>&2
echo "ALWAYS use the given --dry-run option first, THEN run again without"  1>&2
echo "rsync --dry-run -s -c --progress -r --inplace $HOME_ESC/ $PUB_ESC/"
