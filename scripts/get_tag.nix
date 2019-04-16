{ bash, nixpkgs1709, wrap }:

wrap {
  name   = "get_tag";
  paths  = [ bash nixpkgs1709.kid3 ];
  vars   = { DISPLAY = ":0"; };
  script = ''
    #!/usr/bin/env bash

    export DISPLAY=:0

    TAG="$1"

    function getTag() {
      NAME=$(basename "$1" | sed -e 's/"/\"/g')
       DIR=$(dirname  "$1")

      kid3-cli -c 'select "'"$NAME"'"' -c 'get "'"$TAG"'"' "$DIR"
    }

    shift

    for ARG in "$@"
    do
      getTag "$ARG"
    done
  '';
}
