{ bash, mkBin, xidel }:

mkBin {
  name = "album_names_from";
  paths = [ bash xidel ];
  script = ''
    #!/usr/bin/env bash
    xidel -s - -e '//td/a[@class="album"]/(text() || "	" || @href)'
  '';
}
