{ bash, mkBin }:

mkBin {
  name = "move_contents";
  file = ./move_contents.sh;
}
