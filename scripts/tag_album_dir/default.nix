{ bash, mkBin }:

mkBin {
  name = "tag_album_dir";
  file = ./tag_album_dir.sh;
}