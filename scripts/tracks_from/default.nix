{ bash, mkBin, xidel }:

mkBin {
  name = "tracks_from";
  paths = [ bash xidel ];
  vars = {
    expr = builtins.concatStringsSep "" [
      ''//div[@id="album_tabs_tracklist"]//tr[@class="odd" or ''
      ''@class="even"]/(td[position() = 1] || ''
      ''"	" || td[position() = 2])''
    ];
  };
  script = ''
    #!/usr/bin/env bash
    # shellcheck disable=SC2154
    xidel -s - -e "$expr"
  '';
}
