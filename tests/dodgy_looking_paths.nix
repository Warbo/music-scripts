{ fail, runCommand, scripts, testData}: {
  dodgyExtensions = runCommand "test-dodgy-extensions"
    {
      inherit testData;
      buildInputs = [ fail scripts ];
    }
    ''
      NOEXT='Music/Commercial/E/Extended/An Album/foo'

      function gotExtension {
        F="$NOEXT.$1"
        D=$(dirname "$F")

        mkdir -p "$D"
        touch "$F"

        GOT=$(dodgy_looking_paths "$D")
        echo "$GOT" | grep -- "$NOEXT" > /dev/null ||
          fail "No mention of '$NOEXT' in '$GOT'"
      }

      for E in mka oga wav mp4 avi
      do
        gotExtension "$E"
      done

      mkdir "$out"
    '';

  colons = runCommand "test-dodgy-colons"
    {
      inherit testData;
      buildInputs = [ fail scripts ];
    }
    ''
      pushd "$testData"
      GOT=$(dodgy_looking_paths Music)

      function found {
        # Need to double-up backslashes for grep
        PAT=$(echo "$1" | sed -e 's/\\/\\\\/g')
        echo "$GOT" | grep "$PAT" > /dev/null || {
          echo "Didn't spot '$1' in '$GOT'" 1>&2
          exit 1
        }
      }

      TICK="'"
        BS="\\"

      found 'Found colon'
      found '/Dodgy - The FAT Incompatibility'
      found "/Dodgy: The FAT Incompatibility/02 I$TICK$BS$TICK''${TICK}m Pretty - Dodgy.mp3"
      mkdir "$out"
    '';
}
