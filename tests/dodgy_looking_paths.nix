{ fail, runCommand, scripts, testData}: {
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
}
