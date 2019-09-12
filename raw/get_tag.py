#!/usr/bin/env python
import mutagen
import mutagen.easyid3
import sys

tag = sys.argv[1]

for f in sys.argv[2:]:
    try:
        audio = mutagen.easyid3.EasyID3(f)
    except:
        audio = mutagen.File(f)
    try:
        print(audio[tag][0])
    except:
        sys.exit(1)
