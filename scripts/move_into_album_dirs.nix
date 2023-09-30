{ bash, fail, wrap }:

wrap {
  name = "move_into_album_dirs";
  file = ../raw/move_into_album_dirs.sh;
  paths = [ bash fail ];
}
