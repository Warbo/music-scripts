{ bash, mkBin }:

mkBin {
  name = "check_tags";
  file = ./check_tags.sh;
}
