#!/usr/bin/env python3
from os      import listdir
from os.path import exists
from sys     import argv, stderr, stdout

msg  = lambda m: (stderr.write(m), stderr.flush())
ids  = {}
root = '.acoustid_cache'

def strip(arg):
    bits = arg.split('/')

    assert bits[-4:-2] == ['Music', 'Commercial'], repr({
        'error': 'Arguments should end in Music/Commercial/<init>/<artist>',
        'arg'  : arg
    })

    return bits[-2:]

given = list(map(strip, argv[1:]))
if given == []:
    inits   = listdir(root)
    artists = lambda i: listdir(root + '/' + i)
else:
    msg('Limiting our search to the given paths ' + repr(given) + '\n')
    inits   = list(set([arg[0] for arg in given]))
    artists = lambda i: [arg[1] for arg in given if arg[0] == i]

msg('Reading cached AcoustIDs')
for init in inits:
    d = root + '/' + init
    for artist in artists(init):
        a = d + '/' + artist
        msg('.')
        with open(a, 'rb') as f:
            for line in f.readlines():
                (path, duration, fingerprint) = line.split(b'\t')
                if fingerprint not in ids:
                    ids[fingerprint] = []
                    ids[fingerprint].append((int(duration.decode('utf-8')),
                                             path))
msg('\n')

msg('Looking for duplicates.\n')
msg('We include durations since AcoustID only uses the first 2 minutes.\n')
for fingerprint in ids:
    entry = ids[fingerprint]

    # Only process fingerprints which were found in multiple files
    if len(entry) > 1:
        # Filter out any paths which no longer exist and check again
        entry = [(duration, path) for (duration, path) in entry if exists(path)]
        if len(entry) > 1:
            print('The following files have the same AcoustID:')
            for (duration, path) in entry:
                print(str(duration) + '\t', end='', flush=True)
                stdout.buffer.write(path)
                stdout.write('\n')
                stdout.flush()
