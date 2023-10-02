{ nix-helpers, nixpkgs, nixpkgs-lib, warbo-packages, warbo-utilities }:
with rec {
  inherit (builtins) attrValues filter;
  inherit (nix-helpers) nixDirsIn withDeps;
  inherit (nixpkgs) buildEnv newScope;
  inherit (nixpkgs-lib) isDerivation mapAttrs;

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

  combined = withDeps [ check ] (buildEnv {
    name = "music-scripts";
    paths = filter isDerivation (attrValues music-scripts);
  });
};
combined // {
  inherit music-scripts testData;
}
