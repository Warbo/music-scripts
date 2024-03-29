{ testData, fail, mkBin, music-scripts, python3, runCommand, withDeps }:

with rec {
  set_tag = mkBin {
    name = "set_tag";
    paths = [ (python3.withPackages (p: [ p.mutagen ])) ];
    file = ./set_tag.py;
  };

  # NOTE: We use set_tag in some of our testData, so be careful which parts of
  # testData we depend on here (to avoid circular definitions!)
  tests = {
    canSetTitle = runCommand "can-set-title" {
      inherit (testData.emptyAudio) mp3;
      buildInputs = [ fail music-scripts.get_tag set_tag ];
    } ''
      cp -L "$mp3" ./file.mp3
      chmod +w     ./file.mp3

      WANT=MyTitle
      set_tag title "$WANT" ./file.mp3

      GOT=$(get_tag title ./file.mp3)

      echo "WANT: '$WANT', GOT: '$GOT'" 1>&2
      [[ "$WANT" = "$GOT" ]] || fail "Expected '$WANT', got '$GOT'"
      mkdir "$out"
    '';
  };
};
withDeps (builtins.attrValues tests) set_tag
