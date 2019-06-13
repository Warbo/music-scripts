#!/usr/bin/env python
import mutagen
import mutagen.easyid3
import sys

tag = sys.argv[1]
val = sys.argv[2]

for f in sys.argv[3:]:
    try:
        audio = mutagen.easyid3.EasyID3(f)
    except:
        audio = mutagen.File(f)
    audio[tag] = val
    audio.save()
