{ bash, nixpkgs1709, wrap }:

wrap {
  name  = "tag_artist";
  paths = [ bash nixpkgs1709.kid3 ];
  vars  = { DISPLAY = ":0"; };
  file  = ../raw/tag_artist.sh;
}
