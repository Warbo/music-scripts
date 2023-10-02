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

};
combined // {
  inherit music-scripts nix-helpers warbo-packages warbo-utilities;
}
