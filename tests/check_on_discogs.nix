{ fail, runCommand, scripts, xidel }: {
  canSearchArtist = runCommand "can-get-discogs-artist" {
    __noChroot = true;
    buildInputs = [ fail scripts xidel ];
  } ''
    mkdir -p Music/Commercial/M/Meat\ Loaf
    check_on_discogs
    F='.discogs_artist_cache/M/Meat Loaf.search'
    [[ -f "$F" ]] || fail "Didn't make '$F'"
    xidel -q - -e '//img/@alt' < "$F" | grep 'Meat Loaf' > /dev/null ||
      fail "Didn't spot 'Meat Loaf' img alt: $(cat "$F")"
    mkdir "$out"
  '';
}
