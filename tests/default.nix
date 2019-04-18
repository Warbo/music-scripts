{ callPackage, fail, scripts, runCommand }:

with callPackage ./testData.nix {};
{
  # TODO: Make separate files, once we've got a bunch of tests
  albums_of = {
    findAlbums = runCommand "find-albums-of"
      {
        inherit testData;
        buildInputs = [ fail scripts ];
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
        'From Norway One
        From Norway Two'

        check "D/DuplicatedArtist (Swe)" "DuplicatedArtist" "Swe" \
        'From Sweden One
        From Sweden Two'

        check "P/Performer 3" "Performer 3" "" \
        'First Album
        Second Album'

        mkdir "$out"
      '';
  };

  dodgy_looking_paths = {
    dodgyExtensions = runCommand "test-dodgy-extensions"
      {
        inherit testData;
        buildInputs = [ fail scripts ];
      }
      ''
        function gotExtension {
          F="Music/Commercial/E/Extended/An Album/foo.$1"
          D=$(dirname "$F")

          mkdir -p "$D"
          touch "$F"

          GOT=$(dodgy_looking_paths "$D")
          echo "$GOT" | grep -- "$F" > /dev/null ||
            fail "No mention of '$F' in '$GOT'"
        }

        for E in mka oga wav mp4 avi
        do
          gotExtension "$E"
        done

        mkdir "$out"
      '';
  };

  dodgy_looking_tags = {
    equalsInValue = runCommand "test-equals-in-tag"
      {
        inherit (emptyAudio) mp3;
        buildInputs = [ fail scripts ];
      }
      ''
        mkdir data
        cp "$mp3" data/empty.mp3
        chmod -R +w data

        set_tag title "lhr = rhs" data/empty.mp3

        GOT=$(dodgy_looking_tags data)
        echo "$GOT" | grep data/empty.mp3 &&
          fail "An '=' in a tag value shouldn't trigger whitespace warning"
        mkdir "$out"
      '';

    whitespaceBeginning = runCommand "test-whitespace-at-beginning"
      {
        inherit (emptyAudio) mp3;
        buildInputs = [ fail scripts ];
      }
      ''
        mkdir data
        cp "$mp3" data/empty.mp3
        chmod -R +w data

        set_tag title " I start with whitespace" data/empty.mp3

        GOT=$(dodgy_looking_tags data)
        echo "$GOT" | grep 'data/empty.mp3' | grep -i 'whitespace' ||
          fail "Didn't spot leading whitespace in tag"

        mkdir "$out"
      '';
  };
}
