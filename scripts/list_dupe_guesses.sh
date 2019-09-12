#!/usr/bin/env bash

function printDupes {
    # NAMES will contain everything we've seen so far: it is tab-separated, with
    # the full entry followed by the stripped-down version.
    NAMES=""
    while read -r INCOMING
    do
        NAME=$(basename "$INCOMING")
         ALT=$(strip_name "$NAME")

        # See if stripping down this entry makes it appear in anything we've
        # seen already
        echo "$NAMES" | grep -- "$ALT" | cut -f 1 | while read -r DUPE
        do
            # Print out this entry and any of those which matched from NAMES
            # Note that we match with the stripped version (ALT) but print out
            # the unstripped entries (INCOMING and DUPE)
            printf "%s\\t%s\\n" "$INCOMING" "$DUPE"
        done

        # Create or extend NAMES with this entry and its stripped version
        if [[ -z "$NAMES" ]]
        then
            NAMES=$(printf "%s\\t%s"               "$INCOMING" "$ALT")
        else
            NAMES=$(printf "%s\\n%s\\t%s" "$NAMES" "$INCOMING" "$ALT")
        fi
    done
}

# Since we look for one string inside another, the order in which we compare
# them matters. The order that entries are given also affects which we pick as
# being the canonical entry and which are considered dupes.
# For these reasons, we randomise the order that we traverse our input. This way
# we can simply ignore those suggestions which are the wrong way around, since
# they'll probably come out the correct way around in a future run.
if [[ $(( RANDOM % 2 )) -eq 0 ]]
then
    printDupes
else
    tac | printDupes
fi
