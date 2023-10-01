{ bash, wrap }:

wrap {
  name = "remove_empties";
  file = ./remove_empties.sh;
}
