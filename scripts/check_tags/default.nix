{ bash, mkBin, music-scripts }:

mkBin {
  name = "check_tags";
  file = ./check_tags.sh;
  paths = [ music-scripts.esc ];
}
