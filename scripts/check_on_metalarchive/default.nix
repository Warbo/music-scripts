{ bash, curl, fail, jq, mkBin, music-scripts, xidel }:

mkBin {
  name = "check_on_metalarchive";
  paths = [ bash curl fail jq music-scripts.dir_to_artist_country xidel ];
  file = ./check_on_metalarchive.sh;
}
