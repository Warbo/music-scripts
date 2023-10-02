{ bash, mkBin }:

mkBin {
  name = "list_dupe_guesses";
  file = ./list_dupe_guesses.sh;
}
