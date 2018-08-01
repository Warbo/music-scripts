# Apply our overlay (and some helpers) to a pinned nixpkgs revision
with rec {
  inherit (import ./helpers.nix {}) nix-helpers warbo-packages;

  overlays = [
    (import    "${nix-helpers}/overlay.nix")
    (import "${warbo-packages}/overlay.nix")
    (import                  ./overlay.nix )
  ];

  # Whichever nixpkgs the system provides
  bootstrapPkgs = import <nixpkgs> { inherit overlays; };
};
import bootstrapPkgs.repo1709 { inherit overlays; }
