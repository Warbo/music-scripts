{ python3, wrap }:

wrap {
  name = "get_tag";
  paths = [ (python3.withPackages (p: [ p.mutagen ])) ];
  file = ./get_tag.py;
}
