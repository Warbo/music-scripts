{ bash, curl, fail, wrap }:

wrap {
  name = "check_on_lastfm";
  paths = [ bash curl fail ];
  file = ../raw/check_on_lastfm.sh;
}
