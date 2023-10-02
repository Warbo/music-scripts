{ bash, mkBin, music-scripts }:

mkBin {
  name = "list_dupe_guesses";
  file = ./list_dupe_guesses.sh;
  paths = [ music-scripts.strip_name ];
}
