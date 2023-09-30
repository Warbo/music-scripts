{ callPackage, lib, newScope, nix-helpers, nixFilesIn, scripts }:

with builtins;
with lib;
with rec {
  testData = newScope (nix-helpers // { inherit scripts; }) ./testData.nix { };

  call = newScope (nix-helpers // testData // { inherit scripts; });
};
removeAttrs (mapAttrs (_: f: call f { }) (nixFilesIn ./.)) [
  "default"
  "testData"
]
