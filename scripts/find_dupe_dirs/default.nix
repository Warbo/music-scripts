{ bash, mkBin, music-scripts }:

mkBin {
  name = "find_dupe_dirs";
  file = ./find_dupe_dirs.sh;
  paths = [
    music-scripts.esc
    music-scripts.list_dupe_guesses
    music-scripts.move_command
  ];
}
