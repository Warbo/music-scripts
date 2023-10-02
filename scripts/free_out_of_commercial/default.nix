{ bash, mkBin }:

mkBin {
  name = "free_out_of_commercial";
  file = ./free_out_of_commercial.sh;
}
