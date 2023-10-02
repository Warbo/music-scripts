{ nix-helpers ? warbo-packages.nix-helpers, nixpkgs ? nix-helpers.nixpkgs
, nixpkgs-lib ? nix-helpers.nixpkgs-lib
, warbo-packages ? warbo-utilities.warbo-packages
, warbo-utilities ? import ./warbo-utilities.nix }:

with rec {
  extraArgs = nix-helpers // warbo-packages // { inherit warbo-utilities; };

  callPackage = nixpkgs.newScope extraArgs;

  music-scripts = callPackage ./scripts { };
};
music-scripts // {
  inherit nix-helpers warbo-packages warbo-utilities;
}
