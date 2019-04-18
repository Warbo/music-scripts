{ bash, nixpkgs1709, warbo-utilities-scripts, wrap }:

wrap {
  name  = "set_tag";
  paths = [ bash nixpkgs1709.kid3 ];
  vars  = { xvfb = warbo-utilities-scripts.xvfb-run-safe; };
  file  = ../raw/set_tag.sh;
}
