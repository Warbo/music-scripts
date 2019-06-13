{ bash, python, wrap }:

wrap {
  name   = "tags_of";
  paths  = [ bash (python.withPackages (p: [ p.mutagen ])) ];
  script = ''
    #!/usr/bin/env bash
    mutagen-inspect "$@"
  '';
}
