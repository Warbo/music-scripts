{ bash, mkBin }:

mkBin {
  name = "find_untagged";
  file = ./find_untagged.sh;
}
