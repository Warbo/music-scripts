{ fail, mkBin, music-scripts, writeScript, wrap, xidel }:
with {
  canSearchArtist = wrap {
    name = "can-get-discogs-artist";
    paths = [ fail music-scripts.check_on_discogs xidel ];
    script = ''
      mkdir -p Music/Commercial/M/Meat\ Loaf
      check_on_discogs
      F='.discogs_artist_cache/M/Meat Loaf.search'
      [[ -f "$F" ]] || fail "Didn't make '$F'"
      xidel -s - -e '//img/@alt' < "$F" | grep 'Meat Loaf' > /dev/null ||
        fail "Didn't spot 'Meat Loaf' img alt: $(cat "$F")"
      mkdir "$out"
    '';
  };
};
mkBin {
  name = "check_music_scripts";
  script = ''
    #!/usr/bin/env bash
    set -ex
    "${canSearchArtist}"
  '';
}
