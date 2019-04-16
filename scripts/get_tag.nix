{ bash, nixpkgs1709, wrap }:

wrap {
  name  = "get_tag";
  paths = [ bash nixpkgs1709.kid3 ];
  vars  = { DISPLAY = ":0"; };
  file  = ../raw/get_tag.sh;
}
