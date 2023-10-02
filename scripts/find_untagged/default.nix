{ bash, mkBin, music-scripts }:

mkBin {
  name = "find_untagged";
  file = ./find_untagged.sh;
  paths = [ music-scripts.esc music-scripts.get_tag ];
}
