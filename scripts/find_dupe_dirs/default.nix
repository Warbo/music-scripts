{ bash, mkBin, music-scripts }:

mkBin {
  name = "find_dupe_dirs";
  file = ./find_dupe_dirs.sh;
  paths = [ music-scripts.esc ];
}
