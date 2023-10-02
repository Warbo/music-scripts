{ bash, mkBin }:

mkBin {
  name = "tag_artist";
  paths = [ bash ];
  file = ./tag_artist.sh;
}
