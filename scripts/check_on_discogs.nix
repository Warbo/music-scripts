{ bash, cacert, python, wrap, xidel }:

wrap {
  name  = "check_on_discogs";
  file  = ../raw + "/check_on_discogs.py";
  paths = [ python ];
  vars  = {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    searchedNames = wrap {
      name   = "discogs-artist-name";
      paths  = [ bash xidel ];
      script = ''
        #!/usr/bin/env bash
        set -e
        xidel -q - -e '//a/@href' < "$1" |
          grep '^/artist/'               |
          sed -e 's@^/artist/@@g' -e 's/-/\t/'
      '';
    };
  };
}
