{ bash, wrap, xidel }:

wrap {
  name = "available_tracks";
  file = ../raw/available_tracks.sh;
  paths = [ bash xidel ];
}
