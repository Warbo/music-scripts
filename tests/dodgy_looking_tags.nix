{ emptyAudio, fail, runCommand, scripts, testData }: {
  equalsInValue = runCommand "test-equals-in-tag"
    {
      inherit testData;
      buildInputs = [ fail scripts ];
    }
    ''
      cd "$testData"
      GOT=$(dodgy_looking_tags)
      echo "$GOT" | grep -i 'equals in title\.mp3' &&
        fail "An '=' in a tag value shouldn't trigger whitespace warning"
      mkdir "$out"
    '';

  spaceStart = runCommand "test-whitespace-at-start"
    {
      inherit testData;
      buildInputs = [ fail scripts ];
    }
    ''
      cd "$testData"
      GOT=$(dodgy_looking_tags)
      echo "$GOT" | grep -i 'spaceStart.mp3' |
                    grep -i 'whitespace' ||
        fail "Didn't spot leading whitespace in tag: $GOT"

      mkdir "$out"
    '';

  spaceEnd = runCommand "test-whitespace-at-beginning"
    {
      inherit testData;
      buildInputs = [ fail scripts ];
    }
    ''
      cd "$testData"
      GOT=$(dodgy_looking_tags)
      echo "$GOT" | grep -i 'spaceEnd.mp3' |
                    grep -i 'whitespace' ||
        fail "Didn't spot trailing whitespace in tag: $GOT"

      mkdir "$out"
    '';
}
