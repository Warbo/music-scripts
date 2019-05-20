#!/usr/bin/env python3

## Run this via fix-music.nix, so that dependencies are baked in

'''
This script should act like a 'top level' runner for all of the other things in
here.

Our main problem is that we have lots of files, stored on a bunch of networked
drives. Hence processing them can be slow. To avoid always processing the "A"
artists first, and never getting around to "Z", we introduce some randomness: we
get a list of directories, shuffle it, then work through them all. We do this
for the initials and the artists inside. This way we can leave the script going
to process more and more, we avoid always doing the same ones first, and we
minimise the problem of some artists being picked very rarely.

Once we've chosen an artist, we first perform all filename tests (e.g. looking
for duplicate names) since they're cheap. We then perform the content-based
checks, with as much caching as possible.
'''

from random     import shuffle
from os         import listdir, walk
from os.path    import isdir, isfile, join
from subprocess import run
from sys        import __stdin__, stderr, stdin

root = 'Music/Commercial'

if not isdir(root):
    raise Exception('No "{0}" dir in current working directory'.format(root))

msg = stderr.write

def process_artist(path):
    init = path.split('/')[-2]

    # Simple checks, which don't need any file or Web info
    run(['delete_crap.sh'     , path])
    run(['dodgy_formats'      , path])
    run(['dodgy_looking_paths', path])
    run(['find_dupe_files.sh' , path])
    run(['no_discs'           , path])

    # More expensive checks, which look at file contents
    run(['dodgy_looking_tags', path])

    # Get info from the Web, if available; these should cache themselves
    run(['check_on_metalarchive', path, init])
    # We avoid check_on_lastfm for now, since we don't really use the results
    #run(['check_on_lastfm', path, init])

    # Run calls to action
    run(['available_albums', path      ])
    run(['available_tracks', path, init])

    # Get info from file contents
    run(['gather_acoustids', path])  # AcoustID is robust against encoding

    return

def stdin_gen():
    while not __stdin__.isatty():
        l = stdin.readline().strip()
        if l == '':
            return
        else:
            yield l

def process_stdin():
    have_stdin = False
    for artist in stdin_gen():
        if not have_stdin:
            if artist.strip() == '':
                return have_stdin
            have_stdin = True
            msg('Taking paths from stdin\n')
        process_artist(artist.strip())
    return have_stdin

def scramble(l):
    shuffle(l)
    return l

if not process_stdin():
    msg('Empty stdin, working through artists randomly\n')
    for initial in scramble(listdir(root)):
        init = root + '/' + initial
        run(['dodgy_artist_paths.sh', init])
        for artist in scramble(listdir(init)):
            process_artist(init + '/' + artist)
