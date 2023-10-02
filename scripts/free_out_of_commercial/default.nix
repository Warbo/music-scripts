{ bash, mkBin, music-scripts }:

mkBin {
  name = "free_out_of_commercial";
  file = ./free_out_of_commercial.sh;
  paths = [ music-scripts.move_command ];
}
