{ bash, mkBin }:

mkBin {
  name = "find_dupe_artists";
  file = ./find_dupe_artists.sh;
}
