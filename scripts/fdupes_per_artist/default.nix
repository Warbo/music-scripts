{ bash, mkBin }:

mkBin {
  name = "fdupes_per_artist";
  file = ./fdupes_per_artist.sh;
}
