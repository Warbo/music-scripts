{ bash, mkBin }:

mkBin {
  name = "dir_to_artist_country";
  file = ./dir_to_artist_country.sh;
}
