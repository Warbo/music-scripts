{ fail, runCommand, scripts, testData }: {
  suggestAlbumDir = runCommand "test-suggest-album-dir"
    {
      inherit testData;
      buildInputs = [ fail scripts ];
    }
    ''
      cd "$testData"

      D="Music/Commercial/A/Artist1"
      F="$D/Album2/02 In wrong dir.mp3"
      [[ -e "$F" ]] || fail "No file '$F': $(find "$testData")"

      GOT=$(move_into_album_dirs "$D")
      echo "$GOT" | grep "$F' has album 'Album1'" > /dev/null ||
        fail "Didn't spot warning about '$F': $GOT"

      echo "$GOT" | grep 'mkdir .*Album2' > /dev/null ||
        fail "No mkdir command for Album2 (for $F): $GOT"

      echo "$GOT" | grep 'Album2/' ||
        fail "Didn't spot move command for $F: $GOT"

      mkdir "$out"
    '';

  suggestWithoutDots = runCommand "test-suggest-without-dots"
    {
      inherit testData;
      buildInputs = [ fail scripts ];
    }
    ''
      cd "$testData"

      GOT=$(move_into_album_dirs Music/Commercial/D/Dotty)
      echo "$GOT" | grep -vi 'in the right place' > /dev/null ||
        fail "Shouldn't warn about 'In the Right Place': $GOT"

      echo "$GOT" | grep 'mkdir' | grep '/Beware the Dots' > /dev/null ||
        fail "Should have mkdir for '/Beware the Dots': $GOT"

      echo "$GOT" | grep '/Beware the Dots/' > /dev/null ||
        fail "Should move to 'Beware the Dots/': $GOT"

      mkdir "$out"
    '';

  suggestWithoutColon = runCommand "test-suggest-without-colon"
    {
      inherit testData;
      buildInputs = [ fail scripts ];
    }
    ''
      cd "$testData"

      GOT=$(move_into_album_dirs Music/Commercial/C/Colonic)
      echo "$GOT" | grep -vi 'in the right place' > /dev/null ||
        fail "Shouldn't warn about 'In the Right Place': $GOT"

      echo "$GOT" | grep 'mkdir' | grep '/Colon - Beware' > /dev/null ||
        fail "Should have mkdir for '/Colon - Beware': $GOT"

      echo "$GOT" | grep '/Colon - Beware/' > /dev/null ||
        fail "Should move to 'Colon - Beware/': $GOT"

      mkdir "$out"
    '';
}
