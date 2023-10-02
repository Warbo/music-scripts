{ newScope, nix-helpers, nixpkgs-lib, warbo-packages, warbo-utilities }:
with rec {
  inherit (nix-helpers) nixDirsIn;
  inherit (nixpkgs-lib) mapAttrs;

  testData = call null ./testData.nix;

  check = call null ./check.nix;

  call = _: f:
    newScope (nix-helpers // warbo-packages // {
      inherit music-scripts testData warbo-utilities;
    }) f { };

  music-scripts = mapAttrs call (nixDirsIn {
    dir = ./.;
    filename = "default.nix";
  });
};
music-scripts
