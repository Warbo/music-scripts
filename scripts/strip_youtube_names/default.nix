{ bash, mkBin }:

mkBin {
  name = "strip_youtube_names";
  file = ./strip_youtube_names.sh;
}
