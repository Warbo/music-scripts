{ bash, wrap }:

wrap {
  name  = "check_artist_names";
  paths = [ bash ];
  file  = ../raw/check_artist_names.sh;
}
