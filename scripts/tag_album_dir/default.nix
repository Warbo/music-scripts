{ bash, mkBin, music-scripts }:

mkBin {
  name = "tag_album_dir";
  file = ./tag_album_dir.sh;
  paths = [ music-scripts.set_tag ];
}
