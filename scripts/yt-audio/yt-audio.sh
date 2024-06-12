#!/usr/bin/env bash
set -e
yt-dlp -x -f bestaudio "$@"
