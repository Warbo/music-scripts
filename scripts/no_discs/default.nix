{ bash, convmv, fail, runCommand, testData, withDeps, wrap }:

with rec {
  no_discs = wrap {
    name = "no_discs";
    file = ./no_discs.sh;
    paths = [ bash convmv ];
  };

  tests = {
    findAll = runCommand "find-discs" {
      inherit testData;
      buildInputs = [ fail no_discs ];
    } ''
      cd "$testData"
      GOT=$(no_discs)
      WANT="A/Artist1/Album2 (Disc 1)"
      echo "$GOT" | grep "$WANT" | grep 'disc-specific' > /dev/null ||
        fail "Didn't spot disc-specific '$WANT': $GOT"
      mkdir "$out"
    '';
  };
};
withDeps (builtins.attrValues tests) no_discs
