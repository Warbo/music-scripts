#!/usr/bin/env python
import errno
import os
import subprocess
import sys
import time
from urllib.parse import quote
from urllib.request import Request, urlopen

user_agent = 'WarboTagFixer/1.0'

msg = lambda x: (sys.stderr.write(repr(x)), sys.stderr.flush(), None)[-1]

def get(url):
    time.sleep(3)  # Ensures we never make more than 25 requests per minute
    request = Request(url, headers={'User-Agent': user_agent})
    response = urlopen(request)
    return response.read()

def artist_file_name(initial, name):
    '''Get file path to a particular artist's cache. Creates dir if it doesn't
    exist (eww, side-effects).'''
    d = '.discogs_artist_cache/' + initial
    f = d + '/' + name + '.search'
    try:
        os.makedirs(d)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise

    return f

def download_artist_search(initial, name):
    url     = ''.join(['https://www.discogs.com/search/?q=',
                       quote(strip_country(name))   ,
                       '&type=artist'                      ])
    content = get(url)

    with open(artist_file_name(initial, name), 'w') as f:
        f.write(content.decode('utf-8'))

def get_artist_search(initial, name, download=True):
    '''Get the content of an artist search. If download is True (default), we
    will download a search page if we don't have one cached.'''
    try:
        with open(artist_file_name(initial, name), 'r') as f:
            return f.read()
    except:
        if download:
            download_artist_search(initial, name)
            return get_artist_search(initial, name, download=False)
        raise

def potential_artist_ids(initial, name):
    '''Get a search page and extract the artist IDs from it.'''
    get_artist_search(initial, name)
    output  = subprocess.check_output([os.getenv('searchedNames'),
                                       artist_file_name(initial, name)])
    result  = {}
    for line in output.decode('utf-8').split('\n'):
        if len(line.strip()) == 0: continue
        artistid, name = line.split('\t')
        result[name]   = artistid
    return result

def plausible_artist_name(dirname, urlname):
    '''Whether the name appearing in a discogs URL (urlname) might be that of
    an artist directory (dirname).'''
    dirname = stub_string(strip_country(dirname))
    urlname = stub_string(urlname)
    return fuzzy_match(dirname, urlname)

def stub_string(s):
    '''Lowercase, alphabetical-only version of the given string.'''
    return ''.join([c for c in s.lower() if c.isalpha()])

def fuzzy_match(s1, s2):
    return s1.count(s2) > 0 or s2.count(s1) > 0

def get_artist_id(initial, dirname):
    # Look up search results
    potentials = potential_artist_ids(initial, dirname)

    # Find "exact" matches (ignoring case and non-alphabetical characters)
    exacts     = [urlname for urlname in potentials.keys() \
                           if stub_string(urlname) == \
                              stub_string(strip_country(dirname))]

    # Like 'exacts' but discards those which have extra characters (e.g. digits)
    no_fluff   = [urlname for urlname in exacts \
                           if set([c for c in urlname if c not in ' -']) == \
                              set([c for c in dirname if c not in ' -'])]

    # Fuzzy matches, e.g. where one name is included inside another
    matches    = [urlname for urlname in potentials.keys() \
                           if plausible_artist_name(dirname, urlname)]

    # Unique exact matches are the best we can hope for; use them if found
    if len(exacts) == 1:
        return potentials[exacts[0]]

    # We may have multiple exact matches, in which case narrow-down to no_fluff
    if len(no_fluff) == 1:
        return potentials[no_fluff[0]]

    # We can't rely on exact matches; fall back to a unique fuzzy match
    if len(matches) == 0:
        raise Exception(repr({
            'error'      : 'No plausible discogs matches',
            'dirname'    : dirname,
            'initial'    : initial,
            'exacts'     : exacts,
            'potentials' : potentials,
        }))
    if len(matches) > 1:
        raise Exception(repr({
            'error'      : 'Multiple plausible discogs matches',
            'dirname'    : dirname,
            'initial'    : initial,
            'exacts'     : exacts,
            'matches'    : matches,
            'potentials' : potentials,
        }))
    return potentials[matches[0]]

def strip_country(dirname):
    if dirname.endswith(')'):
        return ' ('.join(dirname.split(' (')[:-1])
    return dirname

for initial in os.listdir('Music/Commercial'):
    for artist in os.listdir('Music/Commercial/' + initial):
        try:
            get_artist_id(initial, artist)
        except Exception as e:
            msg({'error': e})
