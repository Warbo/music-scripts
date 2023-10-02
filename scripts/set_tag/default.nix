{ emptyAudio, fail, python3, runCommand, withDeps, mkBin }:

with rec {
  set_tag = mkBin {
    name = "set_tag";
    paths = [ (python3.withPackages (p: [ p.mutagen ])) ];
    file = ./set_tag.py;
  };

  tests = {
    canSetTitle = runCommand "can-set-title" {
      inherit (emptyAudio) mp3;
      buildInputs = [ fail set_tag ];
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
