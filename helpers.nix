{ fetchgit ? (import <nixpkgs> { config = {}; overlays = []; }).fetchgit }:

rec {
  inherit (import "${warbo-utilities}/helpers.nix" { inherit fetchgit; })
    warbo-packages;

  inherit (import "${warbo-packages }/helpers.nix" { inherit fetchgit; })
    nix-helpers;

  warbo-utilities = fetchgit {
    url    = http://chriswarbo.net/git/warbo-utilities.git;
    rev    = "1a7cb3b";
    sha256 = "1das08lsh23mym5la5kwiavlpfnfrrflq686aj3vmif5w7dchmik";
  };
}
