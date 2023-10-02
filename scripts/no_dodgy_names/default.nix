{ bash, mkBin }:

mkBin {
  name = "no_dodgy_names";
  file = ./no_dodgy_names.sh;
}
