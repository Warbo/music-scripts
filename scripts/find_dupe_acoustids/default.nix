{ bash, mkBin }:

mkBin {
  name = "find_dupe_acoustids";
  file = ./find_dupe_acoustids.py;
}
