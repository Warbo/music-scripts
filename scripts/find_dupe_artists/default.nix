{ bash, mkBin, music-scripts }:

mkBin {
  name = "find_dupe_artists";
  file = ./find_dupe_artists.sh;
  paths = [ music-scripts.list_dupe_guesses ];
}
