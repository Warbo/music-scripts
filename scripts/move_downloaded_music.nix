{ bash, warbo-utilities, wrap }:

wrap {
  name  = "album_names_from";
  paths = [ bash warbo-utilities ];
  file  = ../raw/move_downloaded_music.sh;
}
