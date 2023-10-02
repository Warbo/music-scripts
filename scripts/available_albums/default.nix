{ bash, mkBin, music-scripts, xidel }:

mkBin {
  name = "available_albums";
  paths = [
    bash
    xidel
    music-scripts.albums_of
    music-scripts.esc
    music-scripts.dir_to_artist_country
    music-scripts.move_command
    music-scripts.strip_name
  ];
  file = ./available_albums.sh;
}
