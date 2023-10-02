{ bash, mkBin, music-scripts }:

mkBin {
  name = "check_artist_names";
  paths =
    [ bash music-scripts.check_on_lastfm music-scripts.check_on_metalarchive ];
  file = ./check_artist_names.sh;
}
