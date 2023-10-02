{ bash, mkBin }:

mkBin {
  name = "remove_empties";
  file = ./remove_empties.sh;
}
