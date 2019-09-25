#!/usr/bin/env bash

# Remove characters from the argument which aren't letters and make the result
# lowercase. This increases the chance of spotting duplicates, e.g. if they have
# different capitalisation or punctuation.

echo "$1" | tr '[:upper:]' '[:lower:]' | tr -cd '[:lower:]'
