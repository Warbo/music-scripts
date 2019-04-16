{ bash, nixpkgs1709, wrap }:

wrap {
  name   = "tags_of";
  paths  = [ bash nixpkgs1709.kid3 ];
  vars   = { DISPLAY = ":0"; };
  script = ''
    #!/usr/bin/env bash

    DIR=$(dirname  "$1")
      F=$(basename "$1")

    F_ESC="''${F//\"/\\\"}"

    kid3-cli -c 'select "'"$F_ESC"'"' -c 'get all' "$DIR"
  '';
}
