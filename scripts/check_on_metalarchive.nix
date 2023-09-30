{ bash, curl, fail, jq, wrap, xidel }:

wrap {
  name = "check_on_metalarchive";
  paths = [ bash curl fail jq xidel ];
  file = ../raw/check_on_metalarchive.sh;
}
