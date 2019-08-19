{ fetchgit ? (import <nixpkgs> { config = {}; overlays = []; }).fetchgit }:

rec {
  inherit (import "${warbo-utilities}/helpers.nix" { inherit fetchgit; })
    warbo-packages;

  inherit (import "${warbo-packages }/helpers.nix" { inherit fetchgit; })
    nix-helpers;

  warbo-utilities = fetchgit {
    url    = http://chriswarbo.net/git/warbo-utilities.git;
    rev    = "9680325";
    sha256 = "01c9pfsbqndgc51k0pm4zpvzys4rplw6inblr3vp5hqidsmybiqy";
  };
}
