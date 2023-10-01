{ newScope, nix-helpers, nixpkgs-lib, warbo-packages }:
with rec {
  inherit (nix-helpers) nixDirsIn;
  inherit (nixpkgs-lib) mapAttrs;

  call = _: f:
    newScope (nix-helpers // warbo-packages // { inherit music-scripts; }) f
    { };

  music-scripts = mapAttrs call (nixDirsIn {
    dir = ./.;
    filename = "default.nix";
  });
};
music-scripts
