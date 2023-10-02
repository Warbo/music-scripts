{ bash, mkBin, music-scripts }:

mkBin {
  name = "remove_empties";
  file = ./remove_empties.sh;
  paths = [ music-scripts.esc ];
}
