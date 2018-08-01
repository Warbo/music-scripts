{ fetchgit ? (import <nixpkgs> { config = {}; overlays = []; }).fetchgit }:

{
  nix-helpers = fetchgit {
    url    = http://chriswarbo.net/git/nix-helpers.git;
    rev    = "72d9d88";
    sha256 = "1kggqr07dz2widv895wp8g1x314lqg19p67nzr3b97pg97amhjsi";
  };

  warbo-packages = fetchgit {
    url    = http://chriswarbo.net/git/warbo-packages.git;
    rev    = "6011511";
    sha256 = "0a4rn41k9vaibyvjadhcc8bxfnmjii2047wx1w24m171b95z6rp2";
  };
}
