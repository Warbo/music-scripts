{ bash, fail, runCommand, testData, withDeps, mkBin, xidel }:

with rec {
  albums_of = mkBin {
    name = "albums_of";
    paths = [ bash fail xidel ];
    file = ./albums_of.sh;
  };

  tests = {
    findAlbums = runCommand "find-albums-of" {
      inherit (testData) testData;
      buildInputs = [ fail albums_of ];
      dupNor = ''
        From Norway One
        From Norway Two'';
      dupSwe = ''
        From Sweden One
        From Sweden Two'';
      per3 = ''
        First Album
        Second Album'';
    } ''
      cd "$testData"

      function check {
        GOT=$(albums_of "Music/Commercial/$1" "$2" "$3")
        SORTED=$(echo "$GOT" | sort)

        WANT="$4"

        [[ "$SORTED" = "$WANT" ]] || fail "Expected '$WANT', got '$GOT'"
      }

      check "D/DuplicatedArtist (Nor)" "DuplicatedArtist" "Nor" \
            "$dupNor"

      check "D/DuplicatedArtist (Swe)" "DuplicatedArtist" "Swe" \
            "$dupSwe"

      check "P/Performer 3" "Performer 3" "" \
            "$per3"

      mkdir "$out"
    '';
  };
};
withDeps (builtins.attrValues tests) albums_of
