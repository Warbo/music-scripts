{ bash, wrap, xidel }:

wrap {
  name  = "available_tracks";
  file  = ./available_tracks.sh;
  paths = [ bash xidel ];
}
