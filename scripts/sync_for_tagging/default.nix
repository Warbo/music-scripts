{ bash, mkBin, music-scripts }:

mkBin {
  name = "sync_for_tagging";
  file = ./sync_for_tagging.sh;
  paths = [ music-scripts.esc ];
}
