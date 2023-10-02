{ bash, curl, fail, mkBin, music-scripts }:

mkBin {
  name = "check_on_lastfm";
  paths = [ bash curl fail music-scripts.dir_to_artist_country ];
  file = ./check_on_lastfm.sh;
}
