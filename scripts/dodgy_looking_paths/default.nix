{ bash, convmv, fail, file, mkBin, music-scripts, runCommand, testData, withDeps
}:

with rec {
  dodgy_looking_paths = mkBin {
    name = "dodgy_looking_paths";
    file = ./dodgy_looking_paths.sh;
    paths = [ bash convmv file music-scripts.esc music-scripts.move_command ];
  };

  tests = {
    dodgyExtensions = runCommand "test-dodgy-extensions" {
      inherit (testData) testData;
      buildInputs = [ fail dodgy_looking_paths ];
    } ''
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

    colons = runCommand "test-dodgy-colons" {
      inherit (testData) testData;
      buildInputs = [ fail dodgy_looking_paths ];
    } ''
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
  };
};
withDeps (builtins.attrValues tests) dodgy_looking_paths
