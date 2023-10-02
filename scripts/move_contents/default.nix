{ bash, mkBin, music-scripts }:

mkBin {
  name = "move_contents";
  file = ./move_contents.sh;
  paths = [ music-scripts.move_command ];
}
