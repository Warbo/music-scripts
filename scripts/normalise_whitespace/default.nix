{ bash, mkBin, music-scripts }:

mkBin {
  name = "normalise_whitespace";
  file = ./normalise_whitespace.sh;
  paths = [ music-scripts.move_command ];
}
