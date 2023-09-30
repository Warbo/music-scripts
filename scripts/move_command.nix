{ bash, fail, wrap }:

wrap {
  name = "move_command";
  paths = [ bash fail ];
  file = ../raw/move_command.sh;
}
