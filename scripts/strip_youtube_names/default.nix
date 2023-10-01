{ bash, wrap }:

wrap {
  name = "strip_youtube_names";
  file = ./strip_youtube_names.sh;
}
