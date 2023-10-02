{ bash, mkBin, music-scripts }:

mkBin {
  name = "no_dodgy_names";
  file = ./no_dodgy_names.sh;
  paths = [ music-scripts.esc music-scripts.move_command ];
}
