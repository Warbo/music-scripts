{ bash, cacert, python3, wrap, xidel }:

wrap {
  name = "check_on_discogs";
  file = ./check_on_discogs.py;
  paths = [ python3 ];
  vars = {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    searchedNames = wrap {
      name = "discogs-artist-name";
      paths = [ bash xidel ];
      script = ''
        #!/usr/bin/env bash
        set -e
        xidel -s - -e '//a/@href' < "$1" |
          grep '^/artist/'               |
          sed -e 's@^/artist/@@g' -e 's/-/\t/'
      '';
    };
  };
}
