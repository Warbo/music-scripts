{ bash, mkBin }:

mkBin {
  name = "dodgy_artist_paths";
  file = ./dodgy_artist_paths.sh;
}
