#!/usr/bin/env python
import mutagen
import mutagen.easyid3
import mutagen.mp4
import sys

# MP4 gives 'key error' if we try looking up tags like 'album', so we must swap
# them out for their literal byte sequences.
mp4Replacements = {
    'title' : b'\xa9nam',
    'album' : b'\xa9alb',
    'artist': b'\xa9ART'
}

tag = sys.argv[1]

for f in sys.argv[2:]:
    try:
        audio = mutagen.easyid3.EasyID3(f)
    except:
        if f.lower().endswith('m4a') and tag in mp4Replacements:
            tag   = mp4Replacements[tag]
        audio = mutagen.File(f)
    try:
        print(audio[tag][0])
    except Exception as e:
        sys.stderr.write(repr({
            'error' : 'Failed to read tag',
            'tag'   : tag,
            'file'  : f,
            'exception': e,
            'audio' : audio
        }) + '\n')
        sys.exit(1)
