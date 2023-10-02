{ bash, mkBin }:

mkBin {
  name = "convert_tags";
  file = ./convert_tags.sh;
}
