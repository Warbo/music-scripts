{ callPackage, lib, newScope, nixFilesIn, scripts }:

with builtins;
with lib;
with { testData = callPackage ./testData.nix { inherit scripts; }; };
removeAttrs (mapAttrs (_: f: newScope ({ inherit scripts; } // testData) f {})
                      (nixFilesIn ./.))
            [ "default" "testData" ]
