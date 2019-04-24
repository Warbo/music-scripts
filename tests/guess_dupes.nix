{ fail, runCommand, scripts, testData }:

{
  alphabeticalDupes = runCommand "alphabetical-dupes"
    {
      inherit testData;
      buildInputs = [ fail scripts ];
    }
    ''
      GOT=$(find_dupe_files.sh "$testData")
      NOR="From Norway One/01 A Song.mp3"
      SWE="From Sweden One/01 A Song.mp3"

      # Check that some filename-based guesses show up
      GUESSES=$(echo "$GOT" | grep -A 1000 'Possible dupes:' |
                              grep -v 'is a duplicate of')

      echo "$GUESSES" | grep "$NOR" || fail "Didn't guess Nor dupe: $GOT"
      echo "$GUESSES" | grep "$SWE" || fail "Didn't guess Swe dupe: $GOT"

      # Check that CRCs confirm these guesses
      echo "$GOT" | grep 'is a duplicate of' | grep "$NOR" | grep "$SWE" ||
        fail "Didn't verify that $NOR is dupe of $SWE"

      mkdir "$out"
    '';
}
