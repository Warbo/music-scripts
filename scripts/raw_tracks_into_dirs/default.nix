{ bash, mkBin, music-scripts }:

mkBin {
  name = "raw_tracks_into_dirs";
  file = ./raw_tracks_into_dirs.sh;
  paths = [ music-scripts.esc ];
}
