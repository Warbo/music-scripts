{ bash, wrap }:

wrap {
  name = "raw_tracks_into_dirs";
  file = ./raw_tracks_into_dirs.sh;
}
