#!/usr/bin/env python

# Python script to find duplicate files. For any stdin lines of the form
# "COMPARE\tfoo\tbar", check if the filenames "foo" and "bar" have a suffix
# which appears to be audio ("ogg", "mp3", "aac", etc.); if so, and they both
# have the same suffix, then invoke ffmpeg to get the CRC of their audio data.
# Cache the CRCs, and if they match, print out a command which can be used to
# move one into a "DUPES" directory.

from __future__ import print_function
import re
from shutil     import move
from subprocess import PIPE, Popen
from os         import listdir, makedirs
from os.path    import basename, dirname, exists, isfile, isdir
import sys

def msg(m):
    print(m, file=sys.stderr)
    sys.stderr.flush()

def do_move(src, dest):
    print("mv -v " + shellquote(src) + " \\\n      " + shellquote(dest))

def shellquote(s):
    return "'" + s.replace("'", "'\\''") + "'"

# Read in cached CRCs
crcmap = {}
try:
    with open('.crcs', 'r') as f:
        for line in f.read().splitlines():
            bits = line.split("\t")
            if len(bits) == 2:
                crcmap[bits[1]] = bits[0]
            else:
                msg("Dodgy line in .crcs: " + line)
except IOError:
    msg("No .crcs cache found")

def get_output(*args, **kwargs):
    p        = Popen(*args, stderr=PIPE, stdout=PIPE, **kwargs)
    out, err = p.communicate()
    if p.returncode != 0:
        msg(err.decode('utf-8') + '\n')
    return out.decode('utf-8')

def get_crc(path):
    # Use cached version if available
    if path in crcmap:
        return crcmap[path]

    # Calculate CRC
    msg("Calculating CRC of " + path)
    output = get_output(["ffmpeg", "-i", path, "-f", "crc", "-"])
    crc    = [l for l in output.splitlines() if "CRC" in l][0]

    # Cache for future reference
    crcmap[path] = crc
    with open(".crcs", "a") as f:
        f.write(crc + "\t" + path + "\n")

    return crc

def compare_files(f1, f2):
    if not isfile(f1):
        msg("Can't compare non-existent '" + f1 + "' to '" + f2 + "'")
        raise
    if not isfile(f2):
        msg("Can't compare non-existent '" + f2 + "' to '" + f1 + "'")
        raise

    is_audio = False
    lower1 = f1.lower()
    lower2 = f2.lower()

    for ext in ["mp3", "wma", "aac", "ogg", "m4a", "opus", "wav", "flac"]:
        if lower1.endswith(ext) and lower2.endswith(ext):
            is_audio = True

    if is_audio:
        src = get_crc(f1)
        dst = get_crc(f2)
        if src == dst:
            print(f1 + " is a duplicate of " + f2)
            if isdir("DUPES"):
                d = dirname(f2)
                fname = basename(f2)
                print("mkdir -p " + shellquote("DUPES/" + d))
                do_move(f2, "DUPES/" + d + "/" + fname)
        else:
            msg(f1 + " doesn't match CRC of " + f2)
    else:
        print("Path '" + f1 + "' looks like a dupe of '" + f2 + "'")

# Read lines from stdin like "COMPARE\tfoo\tbar" and compare foo with bar
for line in sys.stdin:
    if line.startswith("COMPARE\t"):
        bits = line.split("\t")
        if len(bits) == 3:
            try:
                compare_files(bits[1], bits[2][:-1]) # Chomp newline
            except Exception as e:
                msg("Exception raised, skipping " + repr(e))
        else:
            msg("Dodgy stdin line: " + line)
    else:
        print(line)
