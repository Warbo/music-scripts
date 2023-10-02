{ python3, mkBin, music-scripts }:

mkBin {
  name = "fix-music";
  file = ./fix-music.py;
  paths = [
    music-scripts.available_albums
    music-scripts.available_tracks
    music-scripts.check_on_lastfm
    music-scripts.check_on_metalarchive
    music-scripts.delete_crap
    music-scripts.dodgy_artist_paths
    music-scripts.dodgy_formats
    music-scripts.dodgy_looking_paths
    music-scripts.dodgy_looking_tags
    music-scripts.find_dupe_acoustids
    music-scripts.find_dupe_dirs
    music-scripts.find_dupe_files
    music-scripts.find_dupe_names
    music-scripts.find_full_albums
    music-scripts.find_untagged
    music-scripts.gather_acoustids
    music-scripts.list_only_dupes
    music-scripts.move_into_album_dirs
    music-scripts.no_discs
    music-scripts.normalise_whitespace
    music-scripts.remove_empties
    music-scripts.strip_dodgy_words
    music-scripts.strip_youtube_names
    python3
  ];
}
