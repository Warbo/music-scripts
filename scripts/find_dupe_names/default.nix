{ bash, mkBin }:

mkBin {
  name = "find_dupe_names";
  file = ./find_dupe_names.sh;
}
