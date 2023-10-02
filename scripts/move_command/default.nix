{ bash, fail, mkBin }:

mkBin {
  name = "move_command";
  paths = [ bash fail ];
  file = ./move_command.sh;
}
