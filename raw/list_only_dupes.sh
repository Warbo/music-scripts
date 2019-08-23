#!/usr/bin/env bash
# Find exact duplicates:
#  - '-r' looks recursively throuhg subdirectories
#  - '-f' prevents the first entry from being displayed; hence all of the shown
#    files will be duplicates that we can delete.
echo "The following files are exact duplicates of some other file"
fdupes -q -f -r "$@"
echo "End duplicates list"
