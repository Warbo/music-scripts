{ bash, python3, wrap }:

wrap {
  name = "tags_of";
  paths = [ bash (python3.withPackages (p: [ p.mutagen ])) ];
  script = ''
    #!/usr/bin/env bash
    mutagen-inspect "$@"
  '';
}
