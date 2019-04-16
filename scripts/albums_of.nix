{ bash, fail, wrap, xidel }:

wrap {
  name  = "albums_of";
  paths = [ bash fail xidel ];
  file  = ../raw/albums_of.sh;
}
