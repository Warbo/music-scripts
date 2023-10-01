{ bash, fdupes, wrap }:

wrap {
  name = "list_only_dupes";
  file = ./list_only_dupes.sh;
  paths = [ bash fdupes ];
}
