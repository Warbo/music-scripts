{ bash, mkBin }:

mkBin {
  name = "get_album";
  file = ./get_album.sh;
}
