{ bash, mkBin, music-scripts }:

mkBin {
  name = "get_album";
  file = ./get_album.sh;
  paths = [ music-scripts.tag_album_dir ];
}
