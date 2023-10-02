{ nix-helpers ? warbo-packages.nix-helpers, nixpkgs ? nix-helpers.nixpkgs
, nixpkgs-lib ? nix-helpers.nixpkgs-lib
, warbo-packages ? warbo-utilities.warbo-packages
, warbo-utilities ? import ./warbo-utilities.nix }:

with rec {
  inherit (builtins) attrValues filter;
  inherit (nixpkgs) buildEnv newScope runCommand shellcheck;
  inherit (nixpkgs-lib) isDerivation;
  inherit (nix-helpers) withDeps;

  extraArgs = nix-helpers // warbo-packages // { inherit warbo-utilities; };

  callPackage = newScope extraArgs;

  music-scripts = callPackage ./scripts { };

  combined = withDeps [ check ] (buildEnv {
    name = "music-scripts";
    paths = filter isDerivation (attrValues music-scripts);
  });

  check = runCommand "check-music-scripts" {
    scripts = ./scripts;
    buildInputs = [ shellcheck ];
    LANG = "en_US.UTF-8";
  } ''
    set -e

    CODE=0
    while read -r SCRIPT
    do
      echo "Checking '$SCRIPT'" 1>&2

      SHEBANG=$(head -n1 < "$SCRIPT")
      echo "$SHEBANG" | grep '^#!' > /dev/null || {
        echo "No shebang in $SCRIPT"
        CODE=1
      } 1>&2

      echo "$SHEBANG" | grep 'usr/bin/env' > /dev/null ||
      echo "$SHEBANG" | grep '/nix/store'  > /dev/null || {
        echo "$SCRIPT didn't use /usr/bin/env or /nix/store: $SHEBANG"
        CODE=1
      } 1>&2

      shellcheck "$SCRIPT" || CODE=1
    done < <(find "$scripts" -iname '*.sh')
    [[ "$CODE" -eq 0 ]] && mkdir "$out"
  '';
};
combined // {
  inherit music-scripts nix-helpers warbo-packages warbo-utilities;
}
