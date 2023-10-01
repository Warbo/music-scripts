{ bash, curl, fail, jq, wrap, xidel }:

wrap {
  name = "check_on_metalarchive";
  paths = [ bash curl fail jq xidel ];
  file = ./check_on_metalarchive.sh;
}
