{ fail, runCommand, scripts, testData }: rec {
  findAlbums = runCommand "find-albums-of"
    {
      inherit testData;
      buildInputs = [ fail scripts ];
      dupNor      = "From Norway One\nFrom Norway Two";
      dupSwe      = "From Sweden One\nFrom Sweden Two";
      per3        = "First Album\nSecond Album";
    }
    ''
      cd "$testData"

      function check {
        GOT=$(albums_of "Music/Commercial/$1" "$2" "$3")
        SORTED=$(echo "$GOT" | sort)

        WANT="$4"

        [[ "x$SORTED" = "x$WANT" ]] || fail "Expected '$WANT', got '$GOT'"
      }

      check "D/DuplicatedArtist (Nor)" "DuplicatedArtist" "Nor" \
            "$dupNor"

      check "D/DuplicatedArtist (Swe)" "DuplicatedArtist" "Swe" \
            "$dupSwe"

      check "P/Performer 3" "Performer 3" "" \
            "$per3"

      mkdir "$out"
    '';
}
