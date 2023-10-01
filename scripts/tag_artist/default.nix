{ bash, wrap }:

wrap {
  name = "tag_artist";
  paths = [ bash ];
  file = ./tag_artist.sh;
}
