{ fail, runCommand, scripts, testData }: rec {
  findAll = runCommand "find-discs" {
    inherit testData;
    buildInputs = [ fail scripts ];
  } ''
    cd "$testData"
    GOT=$(no_discs)
    WANT="A/Artist1/Album2 (Disc 1)"
    echo "$GOT" | grep "$WANT" | grep 'disc-specific' > /dev/null ||
      fail "Didn't spot disc-specific '$WANT': $GOT"
    mkdir "$out"
  '';
}
