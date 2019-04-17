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
        GOT=$(albums_of "Music/Commercial/D/DuplicatedArtist (Nor)" \
                                            DuplicatedArtist  Nor)
        SORTED=$(echo "$GOT" | sort)

        WANT='From Norway One
        From Norway Two'

        [[ "x$SORTED" = "x$WANT" ]] || fail "Expected '$WANT', got '$GOT'"
        mkdir "$out"
      '';
  };
}
