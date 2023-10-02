{ bash, mkBin }:

mkBin {
  name = "sync_for_tagging";
  file = ./sync_for_tagging.sh;
}
