#!/usr/bin/env python3
from os      import listdir
from os.path import exists
from sys     import stderr, stdout

msg  = stderr.write
ids  = {}
root = '.acoustid_cache'

msg('Reading cached AcoustIDs')
for init in listdir(root):
    d = root + '/' + init
    for artist in listdir(d):
        msg('.')
        with open(d + '/' + artist, 'rb') as f:
            for line in f.readlines():
                (path, duration, fingerprint) = line.split(b'\t')
                if fingerprint not in ids:
                    ids[fingerprint] = []
                ids[fingerprint].append((int(duration.decode('utf-8')), path))
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
