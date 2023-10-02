{ bash, mkBin }:

mkBin {
  name = "guess_title";
  file = ./guess_title.py;
}
