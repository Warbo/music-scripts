{ bash, fdupes, mkBin }:

mkBin {
  name = "list_only_dupes";
  file = ./list_only_dupes.sh;
  paths = [ bash fdupes ];
}
