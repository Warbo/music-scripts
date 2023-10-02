{ bash, mkBin, music-scripts, xidel }:

mkBin {
  name = "available_albums";
  paths = [ bash xidel music-scripts.esc ];
  file = ./available_albums.sh;
}
