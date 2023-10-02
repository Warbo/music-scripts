{ bash, mkBin, xidel }:

mkBin {
  name = "available_tracks";
  file = ./available_tracks.sh;
  paths = [ bash xidel ];
}
