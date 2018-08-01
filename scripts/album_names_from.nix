{ bash, wrap, xidel }:

wrap {
  name   = "album_names_from";
  paths  = [ bash xidel ];
  script = ''
    #!/usr/bin/env bash
    xidel -q - -e '//td/a[@class="album"]/(text() || "	" || @href)'
  '';
}
