{ bash, mkBin, music-scripts }:

mkBin {
  name = "strip_youtube_names";
  file = ./strip_youtube_names.sh;
  paths = [ music-scripts.move_command ];
}
