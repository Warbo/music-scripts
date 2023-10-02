{ bash, mkBin }:

mkBin {
  name = "find_full_albums";
  file = ./find_full_albums.sh;
}
