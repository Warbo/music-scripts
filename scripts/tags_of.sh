#!/usr/bin/env bash

DIR=$(dirname  "$1")
F=$(basename "$1")

F_ESC="${F//\"/\\\"}"

kid3-cli -c 'select "'"$F_ESC"'"' -c 'get all' "$DIR"
