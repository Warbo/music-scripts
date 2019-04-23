# Apply our overlay (and some helpers) to a pinned nixpkgs revision
with rec {
  inherit (import ./helpers.nix {}) nix-helpers warbo-packages warbo-utilities;

  overlays = [
    (import "${nix-helpers    }/overlay.nix")
    (import "${warbo-packages }/overlay.nix")
    (import "${warbo-utilities}/overlay.nix")
    (import                  ./overlay.nix )
  ];

  # Whichever nixpkgs the system provides
  bootstrapPkgs = import <nixpkgs> { inherit overlays; };
};
import bootstrapPkgs.repo1809 { inherit overlays; }
