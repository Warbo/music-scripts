{ bash, wrap, xidel }:

wrap {
  name  = "available_albums";
  paths = [ bash xidel ];
  file  = ../raw/available_albums.sh;
}
