{ bash, fail, wrap }:

wrap {
  name = "move_command";
  paths = [ bash fail ];
  file = ./move_command.sh;
}
