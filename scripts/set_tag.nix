{ bash, nixpkgs1709, wrap }:

wrap {
  name  = "set_tag";
  paths = [ bash nixpkgs1709.kid3 ];
  vars  = { DISPLAY = ":0"; };
  file  = ../raw/set_tag.sh;
}
