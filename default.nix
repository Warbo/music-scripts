{ nix-helpers ? warbo-packages.nix-helpers, nixpkgs ? nix-helpers.nixpkgs
, nixpkgs-lib ? nix-helpers.nixpkgs-lib
, warbo-packages ? warbo-utilities.warbo-packages
, warbo-utilities ? import ./warbo-utilities.nix }:

import ./scripts {
  inherit nix-helpers nixpkgs nixpkgs-lib warbo-packages warbo-utilities;
} // {
  inherit nix-helpers warbo-packages warbo-utilities;
}
