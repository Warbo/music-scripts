{ bash, wrap }:

wrap {
  name = "check_artist_names";
  paths = [ bash ];
  file = ./check_artist_names.sh;
}
