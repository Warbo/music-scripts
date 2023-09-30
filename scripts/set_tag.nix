{ python, wrap }:

wrap {
  name = "set_tag";
  paths = [ (python.withPackages (p: [ p.mutagen ])) ];
  file = ../raw/set_tag.py;
}
