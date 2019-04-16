{ bash, curl, fail, wrap }:

wrap {
  name  = "check_on_lastfm";
  paths = [ bash curl fail ];
  file  = ./check_on_lastfm.sh;
}
