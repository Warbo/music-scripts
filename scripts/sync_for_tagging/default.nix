{ bash, wrap }:

wrap {
  name = "sync_for_tagging";
  file = ./sync_for_tagging.sh;
}
