{ bash, fail, wrap }:

wrap {
  name = "move_into_album_dirs";
  file = ./move_into_album_dirs.sh;
  paths = [ bash fail ];
}
