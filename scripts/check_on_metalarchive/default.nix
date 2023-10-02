{ bash, curl, fail, jq, mkBin, xidel }:

mkBin {
  name = "check_on_metalarchive";
  paths = [ bash curl fail jq xidel ];
  file = ./check_on_metalarchive.sh;
}
