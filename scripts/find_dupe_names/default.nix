{ bash, mkBin, music-scripts }:

mkBin {
  name = "find_dupe_names";
  file = ./find_dupe_names.sh;
  paths = [ music-scripts.esc ];
}
