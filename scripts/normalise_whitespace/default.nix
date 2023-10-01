{ bash, wrap }:

wrap {
  name = "normalise_whitespace";
  file = ./normalise_whitespace.sh;
}
