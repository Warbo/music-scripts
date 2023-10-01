{ bash, wrap }:

wrap {
  name = "check_tags";
  file = ./check_tags.sh;
}
