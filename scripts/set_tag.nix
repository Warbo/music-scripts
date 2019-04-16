{ bash, nixpkgs1709, wrap }:

wrap {
  name   = "set_tag";
  paths  = [ bash nixpkgs1709.kid3 ];
  vars   = { DISPLAY = ":0"; };
  script = ''
    #!/usr/bin/env bash

    export DISPLAY=:0

    TAG="$1"
    VAL="$2"

    function setTag() {
      NAME=$(basename "$1" | sed -e 's/"/\"/g')
       DIR=$(dirname  "$1")

      kid3-cli -c 'select "'"$NAME"'"'        \
               -c 'set "'"$TAG"'" "'"$VAL"'"' \
               -c 'save' "$DIR"
    }

    shift
    shift

    for ARG in "$@"
    do
        setTag "$ARG"
    done
  '';
}
