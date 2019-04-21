{ emptyAudio, fail, runCommand, scripts, testData }: {
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
}
