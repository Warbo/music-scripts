{ bash, mkBin, music-scripts, yt-dlp }:

mkBin {
  name = "get_album";
  file = ./get_album.sh;
  paths = [ music-scripts.tag_album_dir yt-dlp ];
}
