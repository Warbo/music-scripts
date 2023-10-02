{ fail, mkBin, music-scripts, runCommand, testData, withDeps }:

with rec {
  find_dupe_files = mkBin {
    name = "find_dupe_files";
    file = ./find_dupe_files.sh;
    paths = [ music-scripts.compare_crcs music-scripts.guess_dupes ];
  };

  tests = {
    alphabeticalDupes = runCommand "alphabetical-dupes" {
      inherit (testData) testData;
      buildInputs = [ fail find_dupe_files ];
    } ''
      GOT=$(find_dupe_files "$testData")
      NOR="From Norway One/01 A Song.mp3"
      SWE="From Sweden One/01 A Song.mp3"

      # Check that some filename-based guesses show up
      GUESSES=$(echo "$GOT" | grep -A 1000 'Possible dupes:' |
                              grep -v 'is a duplicate of')

      echo "$GUESSES" | grep "$NOR" > /dev/null ||
        fail "Didn't guess Nor dupe: $GOT"
      echo "$GUESSES" | grep "$SWE" > /dev/null ||
        fail "Didn't guess Swe dupe: $GOT"

      # Check that CRCs confirm these guesses
      echo "$GOT" | grep 'is a duplicate of' | grep "$NOR" |
                                               grep "$SWE" > /dev/null ||
        fail "Didn't verify that $NOR is dupe of $SWE"

      mkdir "$out"
    '';
  };
};
withDeps (builtins.attrValues tests) find_dupe_files
