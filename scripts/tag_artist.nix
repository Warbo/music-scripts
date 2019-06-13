{ bash, wrap }:

wrap {
  name  = "tag_artist";
  paths = [ bash ];
  file  = ../raw/tag_artist.sh;
}
