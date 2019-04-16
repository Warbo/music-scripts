{ bash, nixpkgs1709, wrap }:

wrap {
  name  = "tag_album_dir";
  paths = [ bash nixpkgs1709.ffmpeg nixpkgs1709.libav ];
  file  = ../raw/tag_album_dir.sh;
}
