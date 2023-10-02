{ bash, mkBin }:

mkBin {
  name = "normalise_whitespace";
  file = ./normalise_whitespace.sh;
}
