{ bash, mkBin }:

mkBin {
  name = "delete_crap";
  file = ./delete_crap.sh;
}
