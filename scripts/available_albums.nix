{ bash, wrap, xidel }:

wrap {
  name  = "available_albums";
  paths = [ bash xidel ];
  file  = ./available_albums.sh;
}
