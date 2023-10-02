{ bash, mkBin }:

mkBin {
  name = "find_dupe_dirs";
  file = ./find_dupe_dirs.sh;
}
