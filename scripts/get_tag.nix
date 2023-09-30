{ python, wrap }:

wrap {
  name = "get_tag";
  paths = [ (python.withPackages (p: [ p.mutagen ])) ];
  file = ../raw/get_tag.py;
}
