{ bash, fail, mkBin, music-scripts }:

mkBin {
  name = "move_command";
  paths = [ bash fail music-scripts.esc ];
  file = ./move_command.sh;
}
