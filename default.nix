{ nix-helpers ? warbo-packages.nix-helpers
, warbo-packages ? warbo-utilities.warbo-packages
, warbo-utilities ? import ./warbo-utilities.nix
, nixpkgs-lib ? nix-helpers.nixpkgs-lib, nixpkgs ? nix-helpers.nixpkgs }:

with rec {
  inherit (builtins) attrValues readDir;
  inherit (nixpkgs) newScope runCommand shellcheck;
  inherit (nixpkgs-lib) hasSuffix mapAttrs mapAttrs' removeSuffix;
  inherit (nix-helpers) attrsToDirs' fail withDeps;

  extraArgs = result // nix-helpers // warbo-packages // {
    inherit warbo-utilities;
  };

  callPackage = newScope extraArgs;

  result = {
    music-cmds = callPackage ./scripts { };

    music-scripts = withDeps (attrValues check) (runCommand "music-scripts" {
      bin = attrsToDirs' "commands" result.music-cmds;
      buildInputs = [ nixpkgs.makeWrapper ];
    } ''
      echo "Tying the knot between scripts" 1>&2
      mkdir -p "$out/bin"
      for P in "$bin"/*
      do
        F=$(readlink -f "$P")
        N=$(basename    "$P")
        cp "$F"  "$out/bin/$N"
        chmod +x "$out/bin/$N"
        wrapProgram "$out/bin/$N" --prefix PATH : "$out/bin"
      done
    '');
  };

  check = mapAttrs (name: script:
    runCommand "check-${name}" {
      inherit script;
      buildInputs = [ fail shellcheck ];
      LANG = "en_US.UTF-8";
    } ''
      set -e

      # Unwrap until we get to the real implementation
      while grep "extraFlagsArray" < "$script" > /dev/null
      do
        script=$(grep '^exec' < "$script" | cut -d ' ' -f2 |
                                            tr -d '"')
      done
      echo "Checking '$script'" 1>&2

      SHEBANG=$(head -n1 < "$script")
      echo "$SHEBANG" | grep '^#!' > /dev/null || {
        # Binaries, etc.
        mkdir "$out"
        exit 0
      }

      echo "$SHEBANG" | grep 'usr/bin/env' > /dev/null ||
      echo "$SHEBANG" | grep '/nix/store'  > /dev/null ||
        fail "Didn't use /usr/bin/env or /nix/store:\n$SHEBANG"

      if echo "$SHEBANG" | grep 'bash' > /dev/null
      then
        shellcheck "$script"
      fi
      mkdir "$out"
    '') extraArgs.music-cmds;
};
result.music-scripts // {
  inherit (result) music-cmds;
  helpers = { inherit nix-helpers warbo-packages warbo-utilities; };
  recurseForDerivations = true;
}
