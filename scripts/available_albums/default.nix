{ bash, mkBin, xidel }:

mkBin {
  name = "available_albums";
  paths = [ bash xidel ];
  file = ./available_albums.sh;
}
