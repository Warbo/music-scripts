{ bash, mkBin, music-scripts, xidel }:

mkBin {
  name = "available_tracks";
  file = ./available_tracks.sh;
  paths = [
    bash
    music-scripts.album_names_from
    music-scripts.dir_to_artist_country
    music-scripts.strip_name
    music-scripts.tracks_from
    xidel
  ];
}
